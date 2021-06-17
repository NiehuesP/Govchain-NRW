import 'dart:collection';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:studybuddy/blocs/bloc_provider.dart';
import 'package:studybuddy/blocs/data_bloc.dart';
import 'package:studybuddy/objects/course_object.dart';
import 'package:studybuddy/objects/event_object.dart';
import 'package:studybuddy/objects/event_settings_object.dart';
import 'package:studybuddy/objects/file_upload_object.dart';
import 'package:studybuddy/objects/professor_object.dart';
import 'package:studybuddy/objects/student_event_object.dart';
import 'package:studybuddy/objects/student_exam_object.dart';
import 'package:studybuddy/objects/student_object.dart';
import 'package:studybuddy/services/database_service.dart';
import 'dart:convert';

import 'globals.dart';


class WebService extends ChangeNotifier {
  WebService._privateConstructor();

  static final WebService instance = WebService._privateConstructor();
  static final String endpoint = 'https://10.0.2.2:8443/'; //Emulator localhost, point to your server
  static String dataPath = "";
  static String jwt = "";
  double _downloadProgress = 0;
  get downloadProgress => _downloadProgress;

  DatabaseService db = DatabaseService.instance;

  StompClient stompClient;
  DataBloc _dataBloc;
  void onConnect(StompFrame frame) {
    print("in onConnect");
    stompClient.subscribe(
        destination: '/topic$dataPath',
        callback: (StompFrame frame) async {
          Map<String, dynamic> result = json.decode(frame.body);
          print(result);
          if(!(result["body"] is String)) {
            Map<String, dynamic> body = result["body"];
            if (body.containsKey("studentEvent")) {
              StudentEventObject studentEvent = StudentEventObject.fromMapObject(jsonDecode(body["studentEvent"]));
              await db.updateStudentEvent(studentEvent);
              if(Globals.currentUser is StudentObject) {
                _dataBloc.getMainStudentData(Globals.currentUser.id);
                if(studentEvent.status == "failed") {
                  await db.deleteFileUploadFromStudentEvent(studentEvent.eventId, studentEvent.studentId);
                  _dataBloc.getUploadFileData(Globals.currentUser.id, studentEvent.eventId);
                }
              } else {
                _dataBloc.getPracticumDetailData(studentEvent.eventId);
                _dataBloc.getPracticumData(Globals.currentUser.id);
                _dataBloc.getMainProfessorData(Globals.currentUser.id);
                if(studentEvent.status == "failed") {
                  await db.deleteFileUploadFromStudentEvent(studentEvent.eventId, studentEvent.studentId);
                  _dataBloc.getRequestData(studentEvent.studentId, studentEvent.eventId);
                }
              }
              print(body["studentEvent"]);
            }
            if(body.containsKey("eventSettings")) {
              EventSettingsObject eventSettings = EventSettingsObject.fromMapObject(jsonDecode(body["eventSettings"]));
              await db.updateEventSettings(eventSettings);
              _dataBloc.getModuleData(Globals.currentUser.id);
            }
            if(body.containsKey("studentExam")) {
              StudentExamObject studentExam = StudentExamObject.fromMapObject(jsonDecode(body["studentExam"]));
              await db.updateStudentExam(studentExam);
              _dataBloc.getExamsData(Globals.currentUser.id);
              _dataBloc.getExamsAttendanceData(studentExam.examId);
            }
            if(body.containsKey("fileUpload")) {
              FileUploadObject fileUpload = FileUploadObject.fromMapObject(jsonDecode(body["fileUpload"]));
              await db.insertFileUpload(fileUpload);
              if(Globals.currentUser is StudentObject) {
                _dataBloc.getUploadFileData(Globals.currentUser.id, fileUpload.eventId);
              } else {
                _dataBloc.getRequestData(fileUpload.studentId, fileUpload.eventId);
              }
            }
          } else {
            print(result["body"]);
          }
        });

    stompClient.send(destination: '/app$dataPath');
    stompClient.send(destination: '/app$dataPath');
  }

  Future<dynamic> login(String username, String password, BuildContext context) async {
    _dataBloc = BlocProvider.of<DataBloc>(context);
    String url = '${endpoint}login';
    String body = '''{
      "username": "$username",
      "password": "$password"
    }''';
    final response = await http.post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body);
    if(response.statusCode == 200) {
    final responseJson = jsonDecode(response.body);

      jwt = responseJson["token"];
      if (responseJson["student"] != null) {
        print("student");
        StudentObject student = StudentObject.fromMapObject(jsonDecode(responseJson["student"]));
        await getStudentData(student.id);
        dataPath = "/studentData/${student.id}";
        startWebSocket();
        return student;
      } else if (responseJson["professor"] != null) {
        print("professor");
        ProfessorObject professor = ProfessorObject.fromMapObject(jsonDecode(responseJson["professor"]));
        await getProfessorData(professor.id);
        dataPath = "/professorData/${professor.id}";
        startWebSocket();
        return professor;
      }
    }
    return null;
  }

  uploadFile(File file, int eventId, int studentId) async {
    String url = "${endpoint}uploadFile/$eventId/$studentId";
    var request = http.MultipartRequest("POST", Uri.parse(url));
    request.files.add(http.MultipartFile("file", file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split("/").last));
    request.headers[HttpHeaders.authorizationHeader] = "Bearer $jwt";
    var response = await request.send();
    print(response.stream);
    var res = await http.Response.fromStream(response);
    print(res.body);
  }

  uploadFiles(List<File> fileList, int eventId, int studentId) async {
    String url = "${endpoint}uploadMultipleFiles/$eventId/$studentId";
    var request = http.MultipartRequest("POST", Uri.parse(url));
    fileList.forEach((file) {
      request.files.add(http.MultipartFile("files", file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split("/").last));
    });
    request.headers[HttpHeaders.authorizationHeader] = "Bearer $jwt";
    var response = await request.send();
    print(response.stream);
    var res = await http.Response.fromStream(response);
    print(res.statusCode);
    print("Response body: " + res.body);
  }

  uploadCertificate(File file, int courseId, int studentId) async {
    String url = "${endpoint}uploadCertificate/$courseId/$studentId";
    var request = http.MultipartRequest("POST", Uri.parse(url));
    request.files.add(http.MultipartFile("file", file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split("/").last));
    request.headers[HttpHeaders.authorizationHeader] = "Bearer $jwt";
    var response = await request.send();
    print(response.stream);
    var res = await http.Response.fromStream(response);
    print(res.body);
  }

  downloadFile(int eventId, String eventName, int studentId, String studentFhIdentifier, String name) async {
    _downloadProgress = null;
    notifyListeners();
    String url = "${endpoint}downloadFile/$eventId/$studentId/$name";

    var req = http.Request('GET', Uri.parse(url));
    req.headers[HttpHeaders.authorizationHeader] = "Bearer $jwt";
    final http.StreamedResponse streamedResponse = await http.Client().send(req);
    print(streamedResponse.statusCode);
    print(streamedResponse.headers);
    final contentLength = streamedResponse.contentLength;

    _downloadProgress = 0;
    notifyListeners();

    List<int> fileBytes = [];
    final String dir = (await getExternalStorageDirectory()).path;
    await Directory('$dir/Downloads/$eventName/$studentFhIdentifier').create(recursive: true);
    File file = new File('$dir/Downloads/$eventName/$studentFhIdentifier/$name');

    streamedResponse.stream.listen(
          (List<int> newBytes) {
        // update progress
            fileBytes.addAll(newBytes);
            print("#######################################");
            print(fileBytes.length);
            if(contentLength != null) {
              print((fileBytes.length / contentLength).toString());
              _downloadProgress = fileBytes.length / contentLength;
              notifyListeners();
            }
            print("#######################################");
      },
      onDone: () async {
        // save file
        _downloadProgress = 0;
        notifyListeners();
        print("writing file");
        await file.writeAsBytes(fileBytes);
        Fluttertoast.showToast(
            msg: 'Die Datei wurde erfolgreich heruntergeladen.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Color(0xff2b2a39),
            textColor: Colors.white
        );
      },
      onError: (e) {
        print(e);
        Fluttertoast.showToast(
            msg: 'Die Datei konnte nicht heruntergeladen werden. Bitte versuchen Sie es erneut.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Color(0xff2b2a39),
            textColor: Colors.white
        );
      },
      cancelOnError: true,
    );
  }

  downloadCertificate(int courseId, int studentId, String studentFhIdentifier, String name) async {
    String url = "${endpoint}downloadCertificate/$courseId/$studentId/$name";

    var req = http.Request('GET', Uri.parse(url));
    req.headers[HttpHeaders.authorizationHeader] = "Bearer $jwt";
    final http.StreamedResponse streamedResponse = await http.Client().send(req);
    print(streamedResponse.statusCode);
    print(streamedResponse.headers);

    List<int> fileBytes = [];
    final String dir = (await getExternalStorageDirectory()).path;
    await Directory('$dir/Downloads/Testate/$studentFhIdentifier').create(recursive: true);
    File file = new File('$dir/Downloads/Testate/$studentFhIdentifier/$name');

    streamedResponse.stream.listen(
          (List<int> newBytes) {
        // update progress
        fileBytes.addAll(newBytes);
      },
      onDone: () async {
        // save file
        await file.writeAsBytes(fileBytes);
        Fluttertoast.showToast(
            msg: 'Die Datei wurde erfolgreich heruntergeladen.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Color(0xff2b2a39),
            textColor: Colors.white
        );
      },
      onError: (e) {
        print(e);
        Fluttertoast.showToast(
            msg: 'Die Datei konnte nicht heruntergeladen werden. Bitte versuchen Sie es erneut.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Color(0xff2b2a39),
            textColor: Colors.white
        );
      },
      cancelOnError: true,
    );
  }

  Future<bool> updateStudentEvent(StudentEventObject studentEvent) async {
    String url = "${endpoint}main/studentEvent";
    final response = await http.post(Uri.parse(url), headers: {"Content-Type": "application/json", HttpHeaders.authorizationHeader: "Bearer $jwt"}, body: jsonEncode(studentEvent.toMap()));
    print(response.body);
    print(response.statusCode);
    if(response.statusCode != 200) {
      return false;
    }
    var jsonBody = jsonDecode(response.body);
    if(jsonBody["lastEvent"] == true) {
      return true;
    }
    return false;
  }

  updateEventSettings(EventSettingsObject eventSettings) async {
    String url = "${endpoint}main/eventSettings";
    final response = await http.post(Uri.parse(url), headers: {"Content-Type": "application/json", HttpHeaders.authorizationHeader: "Bearer $jwt"}, body: jsonEncode(eventSettings.toMap()));
    print(response.body);
    print(response.statusCode);
  }

  updateStudentExam(StudentExamObject studentExam) async {
    String url = "${endpoint}main/studentExam";
    final response = await http.post(Uri.parse(url), headers: {"Content-Type": "application/json", HttpHeaders.authorizationHeader: "Bearer $jwt"}, body: jsonEncode(studentExam.toMap()));
    print(response.body);
    print(response.statusCode);
  }

  updateStudentEventWithSettings(StudentEventObject studentEvent) async {
    EventSettingsObject eventSettings = await db.getEventSettingsById(studentEvent.eventId, studentEvent.professorId);

    if(studentEvent.status == "upload") {
      if(eventSettings.needUpload == false) {
        if(eventSettings.autoComplete == false) {
          studentEvent.status = "waiting";
          studentEvent.professorId = null;
          studentEvent.date = null;
          studentEvent.time = null;
        } else {
          studentEvent.status = "completed";
        }
      } else {
        studentEvent.professorId = null;
        studentEvent.date = null;
        studentEvent.time = null;
      }
    } else if(studentEvent.status == "waiting") {
      if(eventSettings.autoComplete == false) {
        studentEvent.professorId = null;
        studentEvent.date = null;
        studentEvent.time = null;
      } else {
        studentEvent.status = "completed";
      }
    }

    String url = "${endpoint}main/studentEvent";
    final response = await http.post(Uri.parse(url), headers: {"Content-Type": "application/json", HttpHeaders.authorizationHeader: "Bearer $jwt"}, body: jsonEncode(studentEvent.toMap()));
    print(response.body);
    print(response.statusCode);
  }

  getStudentData(int studentId) async {
    String url = "${endpoint}main/s?studentId=$studentId";
    final response = await http.get(Uri.parse(url), headers: {"Content-Type": "application/json", HttpHeaders.authorizationHeader: "Bearer $jwt"});
    print(response.body);
    final responseJson = jsonDecode(response.body);
    db.insertStudentData(responseJson);
    List<dynamic> data = responseJson["courseList"];
    print(data.toString());
  }

  getProfessorData(int professorId) async {
    String url = "${endpoint}main/p?professorId=$professorId";
    final response = await http.get(Uri.parse(url), headers: {"Content-Type": "application/json", HttpHeaders.authorizationHeader: "Bearer $jwt"});
    final responseJson = jsonDecode(response.body);
    print(responseJson);
    db.insertProfessorData(responseJson);
  }

  startWebSocket() {
    stompClient = StompClient(
        config: StompConfig.SockJS(
            url: '${endpoint}websocket',
            onConnect: onConnect,
            connectionTimeout: Duration(seconds: 30),
            onWebSocketError: (dynamic error) => print(error.toString()),
            onStompError: (dynamic error) => print(error.toString()),
            onUnhandledMessage: (dynamic error) => print(error.toString()),
            onUnhandledFrame: (dynamic error) => print(error.toString()),
            onUnhandledReceipt: (dynamic error) => print(error.toString()),
            stompConnectHeaders: {'Authorization': 'Bearer $jwt'},
            webSocketConnectHeaders: {'Authorization': 'Bearer $jwt'}));
    stompClient.activate();
  }

  closeWebSocket() {
    if(stompClient != null && stompClient.connected) {
      stompClient.deactivate();
    }
  }

  Future<dynamic> getMainStudentData(int studentId) async {
    String url = '${endpoint}main/s?studentId=$studentId';

    final response = await http.get(Uri.parse(url), headers: {"Content-Type": "application/json", HttpHeaders.authorizationHeader: "Bearer $jwt"});

    if(response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);

      List<dynamic> mainStudentData = [];
      Map<CourseObject, Map<EventObject, String>> eventStatusMap = LinkedHashMap();
      Map<EventObject, String> nextEventsMap = LinkedHashMap();
      Map<String, dynamic> eventStatus = responseJson["eventStatusMap"];

      if(eventStatus != null) {
        eventStatus.forEach((key, value) {
          CourseObject course = CourseObject.fromMapObject(jsonDecode(key));
          Map<String, dynamic> events = value;
          Map<EventObject, String> eventMap = LinkedHashMap();
          events.forEach((key, value) {
            EventObject event = EventObject.fromMapObject(jsonDecode(key));
            eventMap.putIfAbsent(event, () => value);
          });
          eventStatusMap.putIfAbsent(course, () => eventMap);
        });
      }

      Map<String, dynamic> nextEvents = responseJson["nextEvents"];
      if(nextEvents != null) {
        nextEvents.forEach((key, value) {
          EventObject event = EventObject.fromMapObject(jsonDecode(key));
          nextEventsMap.putIfAbsent(event, () => value);
        });
      }

      mainStudentData.add(eventStatusMap);
      mainStudentData.add(nextEventsMap);
      return mainStudentData;
    }
    return null;
  }
}
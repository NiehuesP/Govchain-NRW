import 'dart:async';

import 'package:studybuddy/services/database_service.dart';

import 'bloc_provider.dart';

class DataBloc implements BlocBase {
  //Get instance of the Repository
  final _database = DatabaseService.instance;
  final _mainStudentController = StreamController<List<dynamic>>.broadcast();
  final _uploadFileController = StreamController<List<dynamic>>.broadcast();

  final _mainProfessorController = StreamController<List<dynamic>>.broadcast();
  final _practicumController = StreamController<List<dynamic>>.broadcast();
  final _practicumDetailController = StreamController<List<dynamic>>.broadcast();
  final _moduleController = StreamController<List<dynamic>>.broadcast();
  final _examsController = StreamController<List<dynamic>>.broadcast();
  final _examsAttendanceController = StreamController<List<dynamic>>.broadcast();
  final _requestController = StreamController<List<dynamic>>.broadcast();

  get mainStudentData => _mainStudentController.stream;
  get uploadFileData => _uploadFileController.stream;

  get mainProfessorData => _mainProfessorController.stream;
  get practicumData => _practicumController.stream;
  get practicumDetailData => _practicumDetailController.stream;
  get moduleData => _moduleController.stream;
  get examsData => _examsController.stream;
  get examsAttendanceData => _examsAttendanceController.stream;
  get requestData => _requestController.stream;

  DataBloc();

  getMainStudentData(studentId) async {
    if(studentId != null) {
      List<dynamic> data = [];
      data.add(await _database.getEventStatusMap(studentId));
      data.add(await _database.getNextEventsMap(studentId));

      _mainStudentController.sink.add(data);
    }
  }

  getUploadFileData(studentId, eventId) async {
    if(studentId != null && eventId != null) {
      List<dynamic> data = [];
      data.add(await _database.getFileUploadMapByStudentAndEvent(studentId, eventId));

      _uploadFileController.sink.add(data);
    }
  }

  getMainProfessorData(professorId) async {
    if(professorId != null) {
      List<dynamic> data = [];
      data.add(await _database.getEventStatusMapProf(professorId));
      data.add(await _database.getNextEventsMapProf(professorId));

      _mainProfessorController.sink.add(data);
    }
  }

  getPracticumData(professorId) async {
    if(professorId != null) {
      List<dynamic> data = [];
      data.add(await _database.getAllCoursesAndEventsOfProfessor(professorId));

      _practicumController.sink.add(data);
    }
  }

  getPracticumDetailData(eventId) async {
    if(eventId != null) {
      List<dynamic> data = [];
      data.add(await _database.getAllStudentsOfEvent(eventId));

      _practicumDetailController.sink.add(data);
    }
  }

  getModuleData(professorId) async {
    if(professorId != null) {
      List<dynamic> data = [];
      data.add(await _database.getEventSettingsMap(professorId));

      _moduleController.sink.add(data);
    }
  }

  getExamsData(professorId) async {
    if(professorId != null) {
      List<dynamic> data = [];
      data.add(await _database.getExamMap(professorId));

      _examsController.sink.add(data);
    }
  }

  getExamsAttendanceData(int examId) async {
    if(examId != null) {
      List<dynamic> data = [];
      data.add(await _database.getExamStudentMap(examId));

      _examsAttendanceController.sink.add(data);
    }
  }

  getRequestData(int studentId, int eventId) async {
    if(studentId != null && eventId != null) {
      List<dynamic> data = [];
      data.add(await _database.getAllFileUploadsOfStudentAndEvent(studentId, eventId));

      _requestController.sink.add(data);
    }
  }

  dispose() {
    _mainStudentController.close();
    _mainProfessorController.close();
    _practicumController.close();
    _practicumDetailController.close();
    _moduleController.close();
    _examsController.close();
    _examsAttendanceController.close();
    _uploadFileController.close();
    _requestController.close();
  }
}
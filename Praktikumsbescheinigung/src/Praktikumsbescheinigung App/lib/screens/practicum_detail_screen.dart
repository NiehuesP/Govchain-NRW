import 'dart:collection';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:studybuddy/blocs/bloc_provider.dart';
import 'package:studybuddy/blocs/data_bloc.dart';
import 'package:studybuddy/objects/course_object.dart';
import 'package:studybuddy/objects/event_object.dart';
import 'package:studybuddy/objects/professor_object.dart';
import 'package:studybuddy/objects/student_event_object.dart';
import 'package:studybuddy/objects/student_object.dart';
import 'package:studybuddy/screens/practicum_request_screen.dart';
import 'package:studybuddy/services/blockchain_service.dart';
import 'package:studybuddy/services/globals.dart';
import 'package:studybuddy/services/web_service.dart';
import 'package:studybuddy/widgets/custom_back_button.dart';
import 'package:studybuddy/widgets/menu_button.dart';
import 'package:studybuddy/widgets/menu_drawer.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PracticumDetailScreen extends StatefulWidget {
  PracticumDetailScreen({
    Key key,
    this.event,
    this.course,
  }) : super(key: key);

  final EventObject event;
  final CourseObject course;

  _PracticumDetailScreenState createState() => _PracticumDetailScreenState();
}

class _PracticumDetailScreenState extends State<PracticumDetailScreen> {
  WebService webService = WebService.instance;
  BlockchainService blockchain = BlockchainService.instance;
  DataBloc _dataBloc;
  String _prevPage;
  Map<StudentObject, String> allStudentsMap = LinkedHashMap();
  Map<StudentObject, String> allStudentsItems = LinkedHashMap();
  Map<StudentObject, String> allRequestsMap = LinkedHashMap();
  Map<StudentObject, String> allRequestsItems = LinkedHashMap();
  Map<StudentObject, String> allProcessedMap = LinkedHashMap();
  Map<StudentObject, String> allProcessedItems = LinkedHashMap();
  TextEditingController editingController = TextEditingController();
  List<Widget> pages = [];
  int _current = 0;
  bool _isSearching = false;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  Widget _attestationSearch() {
    return Container(
      margin: EdgeInsets.fromLTRB(ResponsiveFlutter.of(context).scale(16.0),
          0.0, ResponsiveFlutter.of(context).scale(16.0), 0.0),
      width: ResponsiveFlutter.of(context).wp(86.0),
      decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(ResponsiveFlutter.of(context).scale(6.0)),
          color: Color(0xff2b2a39)),
      child: TextField(
        autofocus: false,
        onChanged: (value) {
          filterSearchResults(value);
        },
        controller: editingController,
        style: TextStyle(
          color: Colors.white,
        ),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Durchsuchen...",
          hintStyle: TextStyle(
            color: Colors.white,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          suffixIcon: Container(
            height: ResponsiveFlutter.of(context).verticalScale(20.0),
            child: IconButton(
              icon: Icon(
                Icons.cancel,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  editingController.clear();
                  _isSearching = false;
                  allRequestsItems.clear();
                  allRequestsItems.addAll(allRequestsMap);
                  allStudentsItems.clear();
                  allStudentsItems.addAll(allStudentsMap);
                  allProcessedItems.clear();
                  allProcessedItems.addAll(allProcessedMap);
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  void filterSearchResults(String query) {
    Map<StudentObject, String> dummySearchList = LinkedHashMap();
    if(_current == 0) {
      dummySearchList.addAll(allRequestsMap);
    } else if(_current == 1) {
      dummySearchList.addAll(allStudentsMap);
    } else {
      dummySearchList.addAll(allProcessedMap);
    }
    if (query.isNotEmpty) {
      Map<StudentObject, String> dummyListData = LinkedHashMap();
      dummySearchList.entries.forEach((element) {
        if (element.key.firstName.toLowerCase().contains(query.toLowerCase()) ||
            element.key.lastName.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.putIfAbsent(element.key, () => element.value);
        }
      });
      setState(() {
        if(_current == 0) {
          _isSearching = true;
          allRequestsItems.clear();
          allRequestsItems.addAll(dummyListData);
        } else if(_current == 1) {
          _isSearching = false;
          allStudentsItems.clear();
          allStudentsItems.addAll(dummyListData);
        } else {
          _isSearching = true;
          allProcessedItems.clear();
          allProcessedItems.addAll(dummyListData);
        }
      });
    } else {
      setState(() {
        _isSearching = false;
        if(_current == 0) {
          allRequestsItems.clear();
          allRequestsItems.addAll(allRequestsMap);
        } else if(_current == 1) {
          allStudentsItems.clear();
          allStudentsItems.addAll(allStudentsMap);
        } else {
          allProcessedItems.clear();
          allProcessedItems.addAll(allProcessedMap);
        }
      });
    }
  }

  Widget _processedList() {
    return Container(
      height: ResponsiveFlutter.of(context).verticalScale(240.0),
      child: allProcessedItems.isNotEmpty ? ListView.builder(
        padding: EdgeInsets.zero,
          itemCount: allProcessedItems.keys.length,
          itemBuilder: (context, index) {
        return _processedCard(index);
      }) : Center(
        child: Text(
            'Zur Zeit gibt es keine abgeschlossenen Anfragen.',
          style: TextStyle(
            fontFamily: "Nunito",
            fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
            color: Color(0xff19d9d3),
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Widget _processedCard(int index) {
    StudentObject student = allProcessedItems.keys.toList()[index];
    String status = allProcessedItems.values.toList()[index];
    return Container(
      margin: EdgeInsets.fromLTRB(ResponsiveFlutter.of(context).scale(24.0), 0.0, ResponsiveFlutter.of(context).scale(24.0), ResponsiveFlutter.of(context).verticalScale(8.0)),
      height: ResponsiveFlutter.of(context).verticalScale(48.0),
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                Container(
                  height: ResponsiveFlutter.of(context).verticalScale(40.0),
                  width: ResponsiveFlutter.of(context).scale(40.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(10.0)),
                    border: Border.all(width: ResponsiveFlutter.of(context).scale(2.0), color: Color(0xff6a65a1),),
                  ),
                  child: Icon(status == "completed" ? MdiIcons.fileCheckOutline : MdiIcons.fileExcelOutline, color: Color(0xff6a65a1),),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      String prevPage = Globals.currentPage;
                      Navigator.of(context).push(Globals.slideRight(PracticumRequestScreen(student: student, event: widget.event, status: status, course: widget.course))).then((value) {
                        Globals.currentPage = prevPage;
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(8.0), right: ResponsiveFlutter.of(context).scale(24.0)),
                          child: Text(
                            '${student.lastName}, ${student.firstName}',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                              color: Color(0xff3f3d56),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(8.0), right: ResponsiveFlutter.of(context).scale(24.0)),
                          child: Text(
                            status == "completed" ? "Praktikum bestanden" : "Praktikum nicht bestanden",
                            style: TextStyle(
                              fontFamily: "Nunito",
                              fontSize: ResponsiveFlutter.of(context).fontSize(1.4), //fontSize: 13
                              color: status == "completed" ? Colors.green : Colors.redAccent
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  )
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(right: ResponsiveFlutter.of(context).scale(8.0)),
            child: Icon(Icons.arrow_forward_ios, color: Color(0xff3f3d56)),
          ),
        ],
      ),
    );
  }

  Widget _requestList() {
    return Container(
      height: ResponsiveFlutter.of(context).verticalScale(224.0),
      child: allRequestsItems.isNotEmpty ? ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: allRequestsItems.keys.length,
          itemBuilder: (context, index) {
            return _requestCard(index);
          }) : Center(
        child: Text(
          'Zur Zeit gibt es keine offenen Anfragen.',
          style: TextStyle(
            fontFamily: "Nunito",
            fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
            color: Color(0xff19d9d3),
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Widget _requestCard(int index) {
    StudentObject student = allRequestsItems.keys.toList()[index];
    String status = allRequestsItems.values.toList()[index];
    return Container(
      margin: EdgeInsets.fromLTRB(ResponsiveFlutter.of(context).scale(24.0), 0.0, ResponsiveFlutter.of(context).scale(24.0), ResponsiveFlutter.of(context).verticalScale(8.0)),
      height: ResponsiveFlutter.of(context).verticalScale(48.0),
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Row(children: <Widget>[
              Container(
                  height: ResponsiveFlutter.of(context).verticalScale(40.0),
                  width: ResponsiveFlutter.of(context).scale(40.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(10.0)),
                    border: Border.all(width: ResponsiveFlutter.of(context).scale(2.0), color: Color(0xff6a65a1)),
                    //color: Color(0xff3f3d56),
                  ),

                  child: Icon(status == "waiting" ? MdiIcons.fileCheckOutline : MdiIcons.fileClockOutline, color: Color(0xff6a65a1),),
                ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    String prevPage = Globals.currentPage;
                    Navigator.of(context)
                        .push(
                        Globals.slideRight(PracticumRequestScreen(student: student, event: widget.event, course: widget.course)))
                        .then((value) {
                      Globals.currentPage = prevPage;
                    });
                  },
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(8.0), right: ResponsiveFlutter.of(context).scale(24.0)),
                          child: Text(
                            "${student.lastName}, ${student.firstName}",
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                              color: const Color(0xff3f3d56),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(8.0), right: ResponsiveFlutter.of(context).scale(24.0)),
                          child: Text(
                            status == "waiting" ? "Dateiupload eingereicht" : "Dateiupload ausstehend",
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: ResponsiveFlutter.of(context).fontSize(1.4), //fontSize: 13
                              color: status == "waiting" ? Color(0xff00b1ac) : const Color(0xff6a65a1),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                  ),
                ),
              ),
            ]),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(right: ResponsiveFlutter.of(context).scale(8.0)),
            child: Icon(Icons.arrow_forward_ios, color: Color(0xff3f3d56)),
          ),
        ],
      ),
    );
  }

  Widget _attestationList() {
    return Container(
      height: ResponsiveFlutter.of(context).verticalScale(288.0),
      child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: allStudentsItems.keys.length,
          itemBuilder: (context, index) {
            return _attestationCard(index);
          }),
    );
  }

  Widget _attestationCard(int index) {
    StudentObject student = allStudentsItems.keys.toList()[index];
    String status = allStudentsItems.values.toList()[index];
    String attestationString;
    Color attestationColor;
    if(status == "none") {
      attestationString = "ausstehend";
      attestationColor = Color(0xff6a65a1);
    } else if (status == "failed") {
      attestationString = "nicht erschienen";
      attestationColor = Colors.redAccent;
    } else {
      attestationString = "anwesend";
      attestationColor = Color(0xff00b1ac);
    }
    return Container(
      margin: EdgeInsets.fromLTRB(ResponsiveFlutter.of(context).scale(24.0), 0.0, ResponsiveFlutter.of(context).scale(24.0), ResponsiveFlutter.of(context).verticalScale(8.0)),
      height: ResponsiveFlutter.of(context).verticalScale(48.0),
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Row(children: <Widget>[
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: ResponsiveFlutter.of(context).scale(8.0)),
                        child: Text(
                          "${student.lastName}, ${student.firstName}",
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                            color: const Color(0xff3f3d56),
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: ResponsiveFlutter.of(context).scale(8.0)),
                        child: Text(
                          attestationString,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: ResponsiveFlutter.of(context).fontSize(1.4), //fontSize: 13
                            color: attestationColor,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
              ),
              SizedBox(width: ResponsiveFlutter.of(context).scale(4.0)),
              Container(
                height: ResponsiveFlutter.of(context).verticalScale(40.0),
                width: ResponsiveFlutter.of(context).scale(40.0),
                decoration: BoxDecoration(
                    color: status != "none" && status != "failed" ? Color(0xff00b1ac) : Color(0xffdce4e9),
                    borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(20.0))
                ),
                child:IconButton(
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    DateTime now = DateTime.now();
                    String eventStatus;
                    String date = "${now.day.toString().padLeft(2, "0")}.${now.month.toString().padLeft(2, "0")}.${now.year}";
                    String time = "${now.hour.toString().padLeft(2, "0")}:${now.minute.toString().padLeft(2, "0")}";
                    int professorId = Globals.currentUser.id;
                    if(status == "upload") {
                      eventStatus = "none";
                    } else if(status == "waiting" || status == "completed") {
                      _showAlertDialog(student.id, "none");
                      return;
                    } else {
                      eventStatus = "upload";
                    }
                    StudentEventObject _studentEvent = StudentEventObject(student.id, widget.event.id, professorId, date, time, eventStatus);
                    webService.updateStudentEventWithSettings(_studentEvent);
                  },
                ),
              ),
              SizedBox(width: ResponsiveFlutter.of(context).scale(8.0)),
              Container(
                height: ResponsiveFlutter.of(context).verticalScale(40.0),
                width: ResponsiveFlutter.of(context).scale(40.0),
                decoration: BoxDecoration(
                    color: status == "failed" ? Colors.redAccent : Color(0xffdce4e9),
                    borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(20.0))
                ),
                child:IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () async {
                    String eventStatus;
                    if(status == "failed") {
                      eventStatus = "none";
                    } else if(status == "waiting" || status == "completed") {
                      _showAlertDialog(student.id, "failed");
                      return;
                    } else {
                      eventStatus = "failed";
                    }
                    StudentEventObject _studentEvent = StudentEventObject(student.id, widget.event.id, null, null, null, eventStatus);
                    webService.updateStudentEvent(_studentEvent);
                  },
                ),
              ),
            ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAlertDialog(int studentId, String eventStatus){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Nicht Anwesend?"),
          content: Text("Der Student hat bereits Dateien hochgeladen oder das Praktikum bestanden. Wollen Sie ihn wirklich als nicht Anwesend bestätigen?"),
          actions: [
            TextButton(
                onPressed: () {
              Navigator.of(context).pop();
            },
                child: Text("Abbrechen")),
            TextButton(
                onPressed: () async {
                  StudentEventObject _studentEvent = StudentEventObject(studentId, widget.event.id, null, null, null, eventStatus);
                  webService.updateStudentEvent(_studentEvent);
                  Navigator.of(context).pop();
                },
                child: Text("Bestätigen")),
          ],
        );
      },
    );
  }

  Widget _processedRequests() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(24.0)),
            alignment: Alignment.topLeft,
            child: Text(
              'Bearbeitete Anfragen',
              style: TextStyle(
                fontFamily: "Nunito",
                fontSize: ResponsiveFlutter.of(context).fontSize(2.9), //fontSize: 20
                color: Color(0xff19d9d3),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: ResponsiveFlutter.of(context).verticalScale(8.0)),
          _isSearching && allProcessedItems.isEmpty ? Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.search_off, color: Color(0xff6a65a1), size: ResponsiveFlutter.of(context).verticalScale(64.0)),
                  Text(
                    "Ihre Suchanfrage lieferte keine Ergebnisse.",
                    style: TextStyle(
                      fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                      fontFamily: "Nunito",
                      color: Color(0xff19d9d3)
                    ),
                  ),
                ],
              )
          ) : _processedList(),
        ],
      ),
    );
  }

  Future<File> generatePdf(CourseObject course, StudentEventObject studentEvent, StudentObject student) async {
    final pdf = pw.Document();
    ProfessorObject professor = Globals.currentUser;
    final painter = QrPainter(
      emptyColor: Colors.white,
      errorCorrectionLevel: QrErrorCorrectLevel.Q,
      data: course.id.toString(),
      version: QrVersions.auto,
    );
    ByteData imageData = await painter.toImageData(100.0);
    final imageBytes = imageData.buffer.asUint8List();

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerLeft,
            child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Text("Testatbescheinigung",
                      style: pw.TextStyle(
                        fontSize: 20.0,
                      ),
                      textAlign: pw.TextAlign.left
                  ),
                  pw.SizedBox(height: 16.0),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: <pw.Widget>[
                        pw.Container(
                          width: 280.0,
                          child: pw.Text(
                              "Bescheinigung für das Bestehen des Kurses ${course.name}",
                              style: pw.TextStyle(
                                fontSize: 18.0,
                              )
                          ),
                        ),
                        pw.Image(pw.MemoryImage(imageBytes)),
                      ]
                  ),
                  pw.SizedBox(height: 16.0),
                  pw.Text("Student: ${student.firstName} ${student.lastName}",
                      style: pw.TextStyle(
                          fontSize: 15.0,
                          fontWeight: pw.FontWeight.bold
                      )
                  ),
                  pw.SizedBox(height: 16.0),
                  pw.Text(
                      "Testat erhalten am ${studentEvent.date} um ${studentEvent.time} Uhr",
                      style: pw.TextStyle(
                        fontSize: 15.0,
                      )
                  ),
                  pw.Text("von ${professor.title} ${professor.firstName} ${professor.lastName}",
                      style: pw.TextStyle(
                        fontSize: 15.0,
                      )
                  ),
                ]
            ),
          );
        })); // Page


    pdf.document.info = PdfInfo(pdf.document);
    pdf.document.info.params['/SecurityKey'] =
        PdfSecString.fromString(pdf.document.info, Globals.createCryptoRandomString(64));
    /*final String dir = (await getApplicationDocumentsDirectory()).path;
    final file = new File("$dir/${currentSemester.name.replaceAll(new RegExp(r"\s+"), "_")}.pdf");
    file.create();
    await file.writeAsBytes(await pdf.save()); */

    final String dir = (await getTemporaryDirectory()).path;
    await Directory('$dir/Testate').create(recursive: true);
    final String fileName =  widget.course.name.replaceAll(RegExp(r"\s+"), "_").replaceAll(r".", "_");
    final String path = '$dir/Testate/$fileName.pdf';
    final File file = File(path);
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Widget _openRequests() {
    return Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                  left: ResponsiveFlutter.of(context).scale(24.0)),
              alignment: Alignment.topLeft,
              child: Text(
                'Offene Anfragen',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: ResponsiveFlutter.of(context).fontSize(2.9), //fontSize: 20
                  color: const Color(0xff19d9d3),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: ResponsiveFlutter.of(context).verticalScale(8.0)),
            _isSearching && allRequestsItems.isEmpty ? Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.search_off, color: Color(0xff6a65a1), size: ResponsiveFlutter.of(context).verticalScale(64.0),),
                  Text(
                    "Ihre Suchanfrage lieferte keine Ergebnisse.",
                    style: TextStyle(
                        fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                        fontFamily: "Nunito",
                        color: Color(0xff19d9d3)
                    ),
                  ),
                ],
              ),
            ) : _requestList(),
            SizedBox(height: ResponsiveFlutter.of(context).verticalScale(16.0),),
            Container(
              height: ResponsiveFlutter.of(context).verticalScale(48.0),
              width: ResponsiveFlutter.of(context).wp(86),
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(0.0),
    ),
                  onPressed: () async {
                    if(allRequestsMap.isNotEmpty) {
                      for (StudentObject key in allRequestsMap.keys) {
                        String value = allRequestsMap[key];
                        if (value == "waiting") {
                          DateTime now = DateTime.now();
                          StudentEventObject _studentEvent = StudentEventObject(
                              key.id, widget.event.id, Globals.currentUser.id,
                              "${now.day.toString().padLeft(2, "0")}.${now.month
                                  .toString().padLeft(2, "0")}.${now.year}",
                              "${now.hour.toString().padLeft(2, "0")}:${now
                                  .minute.toString().padLeft(2, "0")}",
                              "completed");
                          bool isLastEvent = await webService.updateStudentEvent(_studentEvent);
                          print("is last event: $isLastEvent");
                          if(isLastEvent) {
                            File pdf = await generatePdf(
                                widget.course, _studentEvent, key);
                            await blockchain.signFile(pdf);
                            await webService.uploadCertificate(
                                pdf, widget.course.id, key.id);
                          }
                        }
                      }
                    }
                  },
                  child: Text(
                    'Alle Anfragen akzeptieren',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: ResponsiveFlutter.of(context).fontSize(2.0), //fontSize: 17
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  )
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(6.0)),
                color: Color(0xff00b1ac),
                border: Border.all(width: ResponsiveFlutter.of(context).scale(2.0), color: Color(0xff00b1ac)),
              ),
            ),
          ],
        ),
    );
  }

  Widget _allParticipants() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                left: ResponsiveFlutter.of(context).scale(24.0)),
            alignment: Alignment.topLeft,
            child: Text(
              'Alle Teilnehmer',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: ResponsiveFlutter.of(context).fontSize(2.9), //fontSize: 20
                color: const Color(0xff19d9d3),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          allStudentsItems.isEmpty ? Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.search_off, color: Color(0xff6a65a1), size: ResponsiveFlutter.of(context).verticalScale(64.0),),
                Text(
                  "Ihre Suchanfrage lieferte keine Ergebnisse.",
                  style: TextStyle(
                      fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                      fontFamily: "Nunito",
                      color: Color(0xff19d9d3)
                  ),
                ),
              ],
            ),
          ) : _attestationList(),
        ],
      ),
    );
  }

  @override
  void initState() {
    _prevPage = Globals.currentPage;
    Globals.currentPage = "practicumDetailScreen";
    _dataBloc = BlocProvider.of<DataBloc>(context);
    _dataBloc.getPracticumDetailData(widget.event.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EventObject currentEvent = widget.event;
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: MenuDrawer(prevPage: _prevPage),
      backgroundColor: Colors.white,
      body: StreamBuilder(
          stream: _dataBloc.practicumDetailData,
          builder: (BuildContext context,
              AsyncSnapshot<List<dynamic>> snapshot,) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              if(snapshot.data[0] != allStudentsMap) {
                allStudentsMap = snapshot.data[0];

                allRequestsMap.clear();
                allProcessedMap.clear();
                allStudentsMap.forEach((key, value) {
                  if (value == "upload" || value == "waiting") {
                    allRequestsMap.putIfAbsent(key, () => value);
                  } else if(value == "failed" || value == "completed") {
                    allProcessedMap.putIfAbsent(key, () => value);
                  }
                });
                editingController.clear();
                _isSearching = false;
                allRequestsItems.clear();
                allRequestsItems.addAll(allRequestsMap);
                allStudentsItems.clear();
                allStudentsItems.addAll(allStudentsMap);
                print("refreshed and added");
                allProcessedItems.clear();
                allProcessedItems.addAll(allProcessedMap);
                if(allRequestsMap.isEmpty) {
                  _current = 1;
                }
              }

              pages.clear();
              pages.add(_openRequests());
              pages.add(_allParticipants());
              pages.add(_processedRequests());
              return  ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: SingleChildScrollView(
                  child: Stack(children: <Widget>[
                Container(
                  height: ResponsiveFlutter.of(context).hp(36),
                  color: Color(0xff3f3d56),
                ),
                MenuButton(scaffoldKey: _scaffoldKey),
                Column(children: <Widget>[
                  SizedBox(
                      height:
                          ResponsiveFlutter.of(context).verticalScale(32.0)),
                  Row(children: <Widget>[
                    CustomBackButton(),
                    Container(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Praktikum',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: ResponsiveFlutter.of(context).fontSize(4.0), //fontSize: 24
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ]
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(16.0),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: ResponsiveFlutter.of(context).scale(24.0), right: ResponsiveFlutter.of(context).scale(8.0)),
                    alignment: Alignment.topLeft,
                    child: Text(
                      '${currentEvent.name}\n${currentEvent.date} ${currentEvent.time.split("-").first} Uhr',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: ResponsiveFlutter.of(context).fontSize(2.9), //fontSize: 20
                        color: const Color(0xff19d9d3),
                      ),
                      textAlign: TextAlign.left,
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(32.0),
                  ),
                  _attestationSearch(),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(32.0),
                  ),
                        CarouselSlider(
                          items: pages,
                          options: CarouselOptions(
                              height: ResponsiveFlutter.of(context).verticalScale(360.0),
                              autoPlay: false,
                              enlargeCenterPage: false,
                              viewportFraction: 1,
                              initialPage: _current,
                              enableInfiniteScroll: false,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  editingController.clear();
                                  _isSearching = false;
                                  allRequestsItems.clear();
                                  allRequestsItems.addAll(allRequestsMap);
                                  allStudentsItems.clear();
                                  allStudentsItems.addAll(allStudentsMap);
                                  allProcessedItems.clear();
                                  allProcessedItems.addAll(allProcessedMap);
                                  _current = index;
                                });
                              }),
                        ),
                        SizedBox(
                          height: ResponsiveFlutter.of(context).verticalScale(4.0),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            crossAxisAlignment:
                            CrossAxisAlignment.end,
                            children: pages.map((url) {
                              int index = pages.indexOf(url);
                              return Container(
                                width: 8.0,
                                height: 8.0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _current == index
                                      ? Color(0xff19d9d3)
                                      : Color(0xff2b2a39),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                ],
                ),
              ],
                  ),
            ),
              );
            } else {
              return Container();
            }
          }),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

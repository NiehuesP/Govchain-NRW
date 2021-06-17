import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:studybuddy/objects/semester_object.dart';
import 'package:studybuddy/objects/student_object.dart';
import 'package:studybuddy/services/database_service.dart';
import 'package:studybuddy/services/globals.dart';
import 'package:studybuddy/widgets/menu_button.dart';
import 'package:studybuddy/widgets/menu_drawer.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class TestamentScreen extends StatefulWidget {
  TestamentScreen({
    Key key,
  }) : super(key: key);

  @override
  _TestamentScreenState createState() => _TestamentScreenState();
}

class _TestamentScreenState extends State<TestamentScreen> {
  List<SemesterObject> semesterList = [];
  List<String> semesterStringList = [];
  SemesterObject currentSemester;
  Future<List<SemesterObject>> _future;
  bool once = true;
  String _prevPage;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  Widget _semesterDropDown() {
    return Container(
      margin: EdgeInsets.fromLTRB(ResponsiveFlutter.of(context).scale(16.0), 0.0, ResponsiveFlutter.of(context).scale(16.0), 0.0),
      width: ResponsiveFlutter.of(context).wp(86),
      padding: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(8.0), right: ResponsiveFlutter.of(context).scale(4.0)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(4.0)),
        color: Color(0xff2b2a39),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        underline: Container(
          color: Colors.transparent,
        ),
        value: currentSemester.name,
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.white,
        ),
        iconSize: 24.0,
        dropdownColor: Color(0xff2b2a39),
        style: TextStyle(color: Colors.white),
        onChanged: (String newValue) {
          for (SemesterObject semester in semesterList) {
            if (semester.name == newValue) {
              setState(() {
                currentSemester = semester;
              });
            }
          }
        },
        items: semesterStringList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                color: Colors.white,
              ),
              textAlign: TextAlign.left,
            ),
          );
        }).toList(),
      ),
    );
  }

  _createPDF() async {
    final pdf = pw.Document();
    StudentObject user = Globals.currentUser;

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerLeft,
              child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget> [
              pw.Text("Studienbescheinigung",
                  style: pw.TextStyle(
                    fontSize: 20.0,
                  ),
                textAlign: pw.TextAlign.left
              ),
              pw.Text("Die mit Hilfe der automatisierten Datenverarebeitung erstellte Bescheinigung ist ohne Unterschrift gültig.",
                  style: pw.TextStyle(
                    fontSize: 10.0,
                  )
              ),
              pw.SizedBox(height: 16.0),
              pw.Text("${user.firstName} ${user.lastName}",
                  style: pw.TextStyle(
                    fontSize: 15.0,
                    fontWeight: pw.FontWeight.bold
                  )
              ),
              pw.Text("geboren am ${user.dateOfBirth}",
                  style: pw.TextStyle(
                    fontSize: 15.0,
                  )
              ),
              pw.Text("Matrikelnummer ${user.matriculation}",
                  style: pw.TextStyle(
                    fontSize: 15.0,
                  )
              ),
              pw.SizedBox(height: 8.0),
              pw.Text("ist im ${currentSemester.name}",
                  style: pw.TextStyle(
                    fontSize: 15.0,
                  )
              ),
              pw.Text("eingeschrieben als Haupthörer(in)",
                  style: pw.TextStyle(
                    fontSize: 15.0,
                  )
              ),
              pw.SizedBox(height: 32.0),
              pw.Text("Studiengang ${user.field}",
                  style: pw.TextStyle(
                    fontSize: 15.0,
                  )
              ),
              pw.Text("Abschluss ${user.degree}",
                  style: pw.TextStyle(
                    fontSize: 15.0,
                  )
              ),
              pw.Text("Fachsemester ${(semesterList.indexOf(currentSemester) - semesterList.length).abs()}",
                  style: pw.TextStyle(
                    fontSize: 15.0,
                  )
              ),
              pw.SizedBox(height: 32.0),
              pw.Text("Beginn an der FH Aachen: ${semesterList.last.name}",
                  style: pw.TextStyle(
                    fontSize: 15.0,
                  )
              ),
              pw.Text("Gültigkeitsdauer der Bescheinigung",
                  style: pw.TextStyle(
                    fontSize: 15.0,
                  )
              ),
              pw.Text("${currentSemester.startDate} bis ${currentSemester.endDate}",
                  style: pw.TextStyle(
                    fontSize: 15.0,
                    fontWeight: pw.FontWeight.bold,
                  )
              ),
            ]
          ),
          );
        })); // Page


    final String dir = (await getExternalStorageDirectory()).path;
    final String fileName = currentSemester.name.replaceAll(RegExp(r"\s+"), "_").replaceAll(r"/", "_");
    final String path = '$dir/Downloads/Studienbescheinigung/$fileName.pdf';
    await Directory(path).create(recursive: true);
    final File file = File(path);
    await file.writeAsBytes(await pdf.save());

    Fluttertoast.showToast(
        msg: 'Das Testat wurde unter $dir/$fileName.pdf gespeichert',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Color(0xff2b2a39),
        textColor: Colors.white
    );
  }

  getData() {
    _future = DatabaseService.instance
        .getAllSemesterOfStudent(Globals.currentUser.id);
  }

  @override
  void initState() {
    _prevPage = Globals.currentPage;
    Globals.currentPage = "testamentScreen";
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    StudentObject user = Globals.currentUser;
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: MenuDrawer(prevPage: _prevPage,),
      backgroundColor: Color(0xffffffff),
      body: FutureBuilder(
          future: _future,
          builder: (BuildContext context,
              AsyncSnapshot<List<SemesterObject>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              if (once) {
                semesterList = snapshot.data;
                if (semesterList.isNotEmpty) {
                  semesterStringList.clear();
                  for (SemesterObject semester in semesterList) {
                    semesterStringList.add(semester.name);
                  }
                  once = false;
                  currentSemester = semesterList.first;
                }
              }

              return Stack(
                children: <Widget>[
                  Container(
                    height: ResponsiveFlutter.of(context).hp(30),
                    color: Color(0xff3f3d56),
                  ),
                  MenuButton(scaffoldKey: _scaffoldKey),
                  Column(
                      children: <Widget>[
                        SizedBox(
                          height: ResponsiveFlutter.of(context).verticalScale(32.0),
                        ),
                        Container(
                          height: ResponsiveFlutter.of(context).verticalScale(44.5),
                          margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(24.0)),
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Belege',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: ResponsiveFlutter.of(context).fontSize(4.0), //fontSize: 24
                              color: const Color(0xffffffff),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
            SizedBox(
            height: ResponsiveFlutter.of(context).verticalScale(16.0),
            ),
                        Container(
                          margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(24.0)),
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Studienbescheinigung',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: ResponsiveFlutter.of(context).fontSize(2.9), //fontSize: 20
                              color: const Color(0xff19d9d3),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveFlutter.of(context).verticalScale(16.0),
                        ),
                        _semesterDropDown(),
                        SizedBox(
                          height: ResponsiveFlutter.of(context).verticalScale(40.0),
                        ),
                        Container(
                          height: ResponsiveFlutter.of(context).verticalScale(260.0),
                          width: ResponsiveFlutter.of(context).wp(86.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Herr',
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                                      color: const Color(0xff3f3d56),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    'Matrikelnummer',
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                                      color: const Color(0xff3f3d56),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    'geboren am',
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                                      color: const Color(0xff3f3d56),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    'Hochschule',
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                                      color: const Color(0xff3f3d56),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    'Fachbereich',
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                                      color: const Color(0xff3f3d56),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  SizedBox(
                                    height: ResponsiveFlutter.of(context).verticalScale(6.0),
                                  ),
                                  Text(
                                    'Studienfach',
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                                      color: const Color(0xff3f3d56),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    'Abschlussziel',
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                                      color: const Color(0xff3f3d56),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    'Fachsemester',
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                                      color: const Color(0xff3f3d56),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    user.firstName + " " + user.lastName,
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                                      color: const Color(0xff3f3d56),
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    user.matriculation.toString(),
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                                      color: const Color(0xff3f3d56),
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    user.dateOfBirth,
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                                      color: const Color(0xff3f3d56),
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    user.university,
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                                      color: const Color(0xff3f3d56),
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Container(
                                    width: ResponsiveFlutter.of(context).scale(170.0),
                                    child: Text(
                                      user.faculty,
                                      style: TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                                        color: const Color(0xff3f3d56),
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Text(
                                    user.field,
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                                      color: const Color(0xff3f3d56),
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    user.degree,
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                                      color: const Color(0xff3f3d56),
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    "${(semesterList.indexOf(currentSemester) - semesterList.length).abs()}",
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                                      color: const Color(0xff3f3d56),
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveFlutter.of(context).verticalScale(16.0),
                        ),
                        Container(
                          width: ResponsiveFlutter.of(context).wp(86.0),
            child: Text(
                          'Der Studierende ist nachweislich im Zeitraum vom ${currentSemester.startDate} bis zum ${currentSemester.endDate} an der FH Aachen immatrikuliert.',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: ResponsiveFlutter.of(context).fontSize(1.6), //fontSize: 14
                            color: const Color(0xff3f3d56),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        ),
                        SizedBox(
                          height: ResponsiveFlutter.of(context).verticalScale(32.0),
                        ),
                        Container(
                          height: ResponsiveFlutter.of(context).verticalScale(48.0),
                          width: ResponsiveFlutter.of(context).wp(86.0),
                          child: TextButton(
                            style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(ResponsiveFlutter.of(context).scale(8.0), 0.0, ResponsiveFlutter.of(context).scale(8.0), 0.0),
            ),
                            onPressed: () {
                              _createPDF();
                            },
                              child: Text(
                                'als PDF-Dokument herunterladen',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: ResponsiveFlutter.of(context).fontSize(2.0), //fontSize: 17
                                  color: const Color(0xffffffff),
                                ),
                                textAlign: TextAlign.center,
                              )
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(6.0)),
                            color: Color(0xff00b1ac),
                            border: Border.all(
                                width: ResponsiveFlutter.of(context).scale(2.0), color: Color(0xff00b1ac)),
                          ),
                        ),
                      ],
                    ),
                ],
              );
            } else {
              return Container();
            }
          }),
    );
  }
}

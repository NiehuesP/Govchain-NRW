
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:studybuddy/blocs/bloc_provider.dart';
import 'package:studybuddy/blocs/data_bloc.dart';
import 'package:studybuddy/objects/student_exam_object.dart';
import 'package:studybuddy/objects/student_object.dart';
import 'package:studybuddy/services/database_service.dart';
import 'package:studybuddy/services/globals.dart';
import 'package:studybuddy/services/web_service.dart';
import 'package:studybuddy/widgets/custom_back_button.dart';
import 'package:studybuddy/widgets/menu_button.dart';
import 'package:studybuddy/widgets/menu_drawer.dart';

class ExamsAttendanceScreen extends StatefulWidget {
  ExamsAttendanceScreen({
    Key key,  this.courseName, this.examId,
  }) : super(key: key);

  final String courseName;
  final int examId;

  _ExamsAttendanceScreenState createState() => _ExamsAttendanceScreenState();
}

class _ExamsAttendanceScreenState extends State<ExamsAttendanceScreen> {
  DatabaseService dbService = DatabaseService.instance;
  WebService webService = WebService.instance;
  DataBloc _dataBloc;
  Map<StudentObject, String> allStudentsMap = LinkedHashMap();
  Map<StudentObject, String> allStudentsItems = LinkedHashMap();
  TextEditingController editingController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  String currentCourse;

  Widget _attendanceSearch() {
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
                  allStudentsItems.clear();
                  allStudentsItems.addAll(allStudentsMap);
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
    dummySearchList.addAll(allStudentsMap);
    if (query.isNotEmpty) {
      Map<StudentObject, String> dummyListData = LinkedHashMap();
      dummySearchList.entries.forEach((element) {
        if (element.key.firstName.toLowerCase().contains(query.toLowerCase()) ||
            element.key.lastName.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.putIfAbsent(element.key, () => element.value);
        }
      });
      setState(() {
          allStudentsItems.clear();
          allStudentsItems.addAll(dummyListData);
      });
    } else {
      setState(() {
          allStudentsItems.clear();
          allStudentsItems.addAll(allStudentsMap);
      });
    }
  }

  Widget _attendanceList() {
    return Expanded(
      child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: allStudentsItems.keys.length,
          itemBuilder: (context, index) {
            return _attendanceCard(index);
          }),
    );
  }

  Widget _attendanceCard(int index) {
    StudentObject student = allStudentsItems.keys.toList()[index];
    String status = allStudentsItems.values.toList()[index];
    String attestationString;
    Color attestationColor;
    if(status == "enrolled") {
      attestationString = "ausstehend";
      attestationColor = Color(0xff6a65a1);
    } else if (status == "absent") {
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
                    color: status != "enrolled" && status != "absent" ? Color(0xff00b1ac) : Color(0xffdce4e9),
                    borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(20.0))
                ),
                child:IconButton(
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    String examStatus;
                    if(status == "present") {
                      examStatus = "enrolled";
                    } else {
                      examStatus = "present";
                    }
                    StudentExamObject studentExam = StudentExamObject(student.id, widget.examId, examStatus);
                    webService.updateStudentExam(studentExam);
                  },
                ),
              ),
              SizedBox(width: ResponsiveFlutter.of(context).scale(8.0)),
              Container(
                height: ResponsiveFlutter.of(context).verticalScale(40.0),
                width: ResponsiveFlutter.of(context).scale(40.0),
                decoration: BoxDecoration(
                    color: status == "absent" ? Colors.redAccent : Color(0xffdce4e9),
                    borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(20.0))
                ),
                child:IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    String examStatus;
                    if(status == "absent") {
                      examStatus = "enrolled";
                    } else {
                      examStatus = "absent";
                    }
                    StudentExamObject studentExam = StudentExamObject(student.id, widget.examId, examStatus);
                    webService.updateStudentExam(studentExam);
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

  @override
  void initState() {
    Globals.currentPage = "examsAttendanceScreen";
    currentCourse = widget.courseName;
    _dataBloc = BlocProvider.of<DataBloc>(context);
    _dataBloc.getExamsAttendanceData(widget.examId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: MenuDrawer(),
      backgroundColor: Colors.white,
      body: StreamBuilder(
          stream: _dataBloc.examsAttendanceData,
          builder: (BuildContext context,
              AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              if(snapshot.data[0] != allStudentsMap) {
                allStudentsMap = snapshot.data[0];
                allStudentsItems.clear();
                allStudentsItems.addAll(allStudentsMap);
              }
              return  Stack(children: <Widget>[
                Container(
                  height: ResponsiveFlutter.of(context).hp(31.0),
                  color: Color(0xff3f3d56),
                ),
                MenuButton(scaffoldKey: _scaffoldKey),
                Column(
                  children: <Widget>[
                    SizedBox(height: ResponsiveFlutter.of(context).verticalScale(32.0)),
                    Row(children: <Widget>[
                      CustomBackButton(),
                      Container(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Klausuren',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: ResponsiveFlutter.of(context).fontSize(4.0), //fontSize: 24
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ]),
                    SizedBox(
                      height: ResponsiveFlutter.of(context).verticalScale(16.0),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(24.0)),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Veranstaltung auswählen',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: ResponsiveFlutter.of(context).fontSize(2.9), //fontSize: 20
                          color: const Color(0xff19d9d3),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      height: ResponsiveFlutter.of(context).verticalScale(24.0),
                    ),
                    _attendanceSearch(),
                    SizedBox(
                      height: ResponsiveFlutter.of(context).verticalScale(32.0),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: ResponsiveFlutter.of(context).scale(24.0)),
                      alignment: Alignment.topLeft,
                      child: Text(
                        currentCourse,
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
                    ) : _attendanceList(),
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
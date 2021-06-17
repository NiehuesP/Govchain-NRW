import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:studybuddy/objects/course_object.dart';
import 'package:studybuddy/objects/course_progress_object.dart';
import 'package:studybuddy/objects/semester_object.dart';
import 'package:studybuddy/screens/attestation_detail_screen.dart';
import 'package:studybuddy/services/database_service.dart';
import 'package:studybuddy/services/globals.dart';
import 'package:studybuddy/widgets/menu_button.dart';
import 'package:studybuddy/widgets/menu_drawer.dart';

class AttestationScreen extends StatefulWidget {
  AttestationScreen({Key key,}) : super(key: key);

  @override
  _AttestationScreenState createState() => _AttestationScreenState();
}

class _AttestationScreenState extends State<AttestationScreen> {
  DatabaseService dbService = DatabaseService.instance;
  Future<Map<SemesterObject, Map<CourseObject, CourseProgressObject>>> _future;
  Map<CourseObject, Map<SemesterObject, CourseProgressObject>> allCoursesMap =
      LinkedHashMap();
  Map<CourseObject, Map<SemesterObject, CourseProgressObject>> allCoursesItems =
      LinkedHashMap();
  TextEditingController editingController = TextEditingController();
  bool once = true;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  Widget _attestationCard(CourseObject course,
      CourseProgressObject courseProgress, SemesterObject semester) {
    return Container(
      margin: EdgeInsets.fromLTRB(ResponsiveFlutter.of(context).scale(16.0), 0.0, ResponsiveFlutter.of(context).scale(16.0), ResponsiveFlutter.of(context).verticalScale(8.0)),
      height: ResponsiveFlutter.of(context).verticalScale(62.0),
      child: InkWell(
        onTap: () async {
          FocusScope.of(context).unfocus();
          Globals.currentCourse = course;
          String prevPage = Globals.currentPage;
          Navigator.push(
              context,
              Globals.slideRight(AttestationDetailScreen(
                course: course,
                courseProgress: courseProgress,
              ))).then((value) {
            Globals.currentPage = prevPage;
          });
        },
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
                          margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(8.0), right: ResponsiveFlutter.of(context).scale(24.0)),
                          child: Text(
                            course.name,
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
                            courseProgress.semesterName,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: ResponsiveFlutter.of(context).fontSize(1.4), //fontSize: 13
                              color: const Color(0xff6a65a1),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(8.0), right: ResponsiveFlutter.of(context).scale(24.0)),
                            child: Text(
                              courseProgress.professorName,
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: ResponsiveFlutter.of(context).fontSize(1.4), //fontSize: 13
                                color: const Color(0xff6a65a1),
                              ),
                              textAlign: TextAlign.left,
                            )),
                        Container(
                          margin: EdgeInsets.only(
                            left: ResponsiveFlutter.of(context).scale(8.0),
                          ),
                          child: Row(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(8.0)),
                                child: Container(
                                  width: ResponsiveFlutter.of(context).wp(75.0),
                                  child: LinearPercentIndicator(
                                    linearStrokeCap: LinearStrokeCap.roundAll,
                                    animation: true,
                                      animationDuration: 1000,
                                      percent: courseProgress.completedEvents /
                                          courseProgress.totalEvents,
                                      backgroundColor: Color(0xfff6f6f6),
                                      progressColor: Color(0xff00b1ac),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: ResponsiveFlutter.of(context).scale(8.0),
                              ),
                              Text(
                                '${courseProgress.completedEvents.toString().padLeft(2, "0")} / ${courseProgress.totalEvents.toString().padLeft(2, "0")}',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: ResponsiveFlutter.of(context).fontSize(1.4), //fontSize: 13
                                  color: const Color(0xff3f3d56),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ]),
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
      ),
    );
  }

  Widget _attestationList() {
    return Expanded(
      child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: allCoursesItems.keys.length,
          itemBuilder: (context, index) {
            return _attestationCard(
                allCoursesItems.keys.toList()[index],
                allCoursesItems.values.toList()[index].values.first,
                allCoursesItems.values.toList()[index].keys.first);
          }),
    );
  }

  Widget _attestationSearch() {
    return Container(
      margin: EdgeInsets.fromLTRB(ResponsiveFlutter.of(context).scale(16.0), 0.0, ResponsiveFlutter.of(context).scale(16.0), 0.0),
      width: ResponsiveFlutter.of(context).wp(86.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(6.0)), color: Color(0xff2b2a39)),
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
                  allCoursesItems.clear();
                  allCoursesItems.addAll(allCoursesMap);
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  void filterSearchResults(String query) {
    Map<CourseObject, Map<SemesterObject, CourseProgressObject>>
        dummySearchList = LinkedHashMap();
    dummySearchList.addAll(allCoursesMap);
    if (query.isNotEmpty) {
      Map<CourseObject, Map<SemesterObject, CourseProgressObject>>
          dummyListData = LinkedHashMap();
      dummySearchList.entries.forEach((element) {
        if (element.key.name.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.putIfAbsent(element.key, () => element.value);
        }
      });
      setState(() {
        allCoursesItems.clear();
        allCoursesItems.addAll(dummyListData);
      });
    } else {
      setState(() {
        allCoursesItems.clear();
        allCoursesItems.addAll(allCoursesMap);
      });
    }
  }

  getData() {
    _future = dbService.getSemesterCourseMapForStudent(Globals.currentUser.id);
  }

  @override
  void initState() {
    Globals.currentPage = "attestationScreen";
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: MenuDrawer(),
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: _future,
          builder: (BuildContext context,
              AsyncSnapshot<
                      Map<SemesterObject,
                          Map<CourseObject, CourseProgressObject>>>
                  snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              if (once) {
                once = false;
                snapshot.data.entries.forEach((element) {
                  SemesterObject semester = element.key;
                  element.value.forEach((key, value) {
                    Map<SemesterObject, CourseProgressObject>
                        semesterProgressMap = LinkedHashMap();
                    semesterProgressMap.putIfAbsent(semester, () => value);
                    allCoursesMap.putIfAbsent(key, () => semesterProgressMap);
                  });
                });
                allCoursesItems.addAll(allCoursesMap);
              }
              return Stack(
                children: <Widget>[
                  Container(
                    height: ResponsiveFlutter.of(context).hp(31.0),
                    color: Color(0xff3f3d56),
                  ),
                  MenuButton(scaffoldKey: _scaffoldKey),
                  Column(
                    children: <Widget>[
                      SizedBox(height: ResponsiveFlutter.of(context).verticalScale(32.0)),
                      Container(
                        height: ResponsiveFlutter.of(context).verticalScale(44.5),
                        margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(24.0)),
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Testate',
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
                      _attestationSearch(),
                      SizedBox(height: ResponsiveFlutter.of(context).verticalScale(32.0)),
                      Container(
                        margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(24.0)),
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Veranstaltungen',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: ResponsiveFlutter.of(context).fontSize(2.9), //fontSize: 20
                            color: const Color(0xff00b1ac),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: ResponsiveFlutter.of(context).verticalScale(16.0)),
                      allCoursesItems.isEmpty ? Expanded(
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
                ],
              );
            } else {
              return Container();
            }
          }),
    );
  }
}

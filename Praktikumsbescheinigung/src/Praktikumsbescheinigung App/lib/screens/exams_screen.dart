
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:studybuddy/blocs/bloc_provider.dart';
import 'package:studybuddy/blocs/data_bloc.dart';
import 'package:studybuddy/objects/exam_data_object.dart';
import 'package:studybuddy/screens/exams_attendance_screen.dart';
import 'package:studybuddy/services/database_service.dart';
import 'package:studybuddy/services/globals.dart';
import 'package:studybuddy/widgets/menu_button.dart';
import 'package:studybuddy/widgets/menu_drawer.dart';

class ExamsScreen extends StatefulWidget {
  ExamsScreen({
    Key key,
  }) : super(key: key);

  _ExamsScreenState createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  DatabaseService dbService = DatabaseService.instance;
  DataBloc _dataBloc;
  Map<String, List<ExamDataObject>> examMap;
  List<ExamDataObject> examList;
  List<String> courseList;
  bool once = true;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  String currentCourse;
  ExamDataObject currentExam;

  Widget _examListWidget() {
    return Expanded(
      child: examList.isNotEmpty ? ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: examList.length,
          itemBuilder: (context, index) {
            currentExam = examList[index];
            return _examCard();
          }
      ) : Center(
        child: Text(
          "Es existieren keine Klausuren zu diesem Kurs",
          style: TextStyle(
            fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
            fontFamily: "Nunito",
            color: Color(0xff3f3d56),
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Widget _examCard() {
    int enrolled = currentExam.enrolledCount;
    int approved = currentExam.approvedCount;
    return Card(
      margin: EdgeInsets.fromLTRB(ResponsiveFlutter.of(context).scale(24.0), 0.0, ResponsiveFlutter.of(context).scale(24.0), ResponsiveFlutter.of(context).verticalScale(8.0)),
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: Color(0xffF8F8FF),
      child: InkWell(
    onTap: () {
    String prevPage = Globals.currentPage;
    Navigator.of(context)
        .push(
    Globals.slideRight(ExamsAttendanceScreen(courseName: currentCourse, examId: currentExam.examId,)))
        .then((value) {
    Globals.currentPage = prevPage;
    });
    },
    child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(8.0)),
            alignment: Alignment.centerLeft,
            height: ResponsiveFlutter.of(context).verticalScale(32.0),
      child: Text(
            currentCourse,
            style: TextStyle(
              color: Color(0xff6a65a1),
              fontFamily: "Nunito",
              fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
              fontWeight: FontWeight.w700,
            ),
          ),
          ),
          Container(
            width: double.infinity,
            height: ResponsiveFlutter.of(context).verticalScale(1.0),
            color: Colors.grey,
          ),
          SizedBox(height: ResponsiveFlutter.of(context).verticalScale(16.0),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(12.0)),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(MdiIcons.school, color: Color(0xff3f3d56),),
                      SizedBox(width: ResponsiveFlutter.of(context).scale(8.0),),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                            color: const Color(0xff6a65a1),
                          ),
                          children: [
                            TextSpan(
                              text: '$enrolled',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: ' angemeldete(r) Teilnehmer',
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveFlutter.of(context).verticalScale(4.0),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(MdiIcons.accountCheck, color: Color(0xff3f3d56),),
                      SizedBox(width: ResponsiveFlutter.of(context).scale(8.0),),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                            color: const Color(0xff6a65a1),
                          ),
                          children: [
                            TextSpan(
                              text: '$approved',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: ' zulassungsberechtigt',
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveFlutter.of(context).verticalScale(4.0),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on, color: Color(0xff3f3d56),),
                      SizedBox(width: ResponsiveFlutter.of(context).scale(8.0),),
                      Text(
                        'Raum ${currentExam.room}',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                            color: const Color(0xff6a65a1),
                          ),

                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ],
              ),
              ),
              Container(
                margin: EdgeInsets.only(right: ResponsiveFlutter.of(context).scale(12.0)),
                child: Icon(Icons.arrow_forward_ios, color: Color(0xff3f3d56)),
              ),
            ],
          ),
          SizedBox(height: ResponsiveFlutter.of(context).verticalScale(16.0),),
          Container(
            height: ResponsiveFlutter.of(context).verticalScale(32.0),
            decoration: BoxDecoration(
              color: Color(0xff3f3d56),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12.0),
                bottomRight: Radius.circular(12.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            Row(
            children: [
              SizedBox(width: ResponsiveFlutter.of(context).scale(8.0),),
              Icon(Icons.calendar_today, color: Color(0xff6a65a1),),
            SizedBox(width: ResponsiveFlutter.of(context).scale(8.0),),
            Text(
              currentExam.date,
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Nunito",
                fontSize: ResponsiveFlutter.of(context).fontSize(1.4), //fontSize: 13
              ),
            )
            ]
            ),
        Row(
          children: [
            Icon(Icons.access_time, color: Color(0xff6a65a1),),
            SizedBox(width: ResponsiveFlutter.of(context).scale(8.0),),
            Text(
              '${currentExam.time} Uhr',
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Nunito",
                fontSize: ResponsiveFlutter.of(context).fontSize(1.4), //fontSize: 13
              ),
            ),
            SizedBox(width: ResponsiveFlutter.of(context).scale(8.0),),
          ]
        ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _courseDropDown() {
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
        value: currentCourse,
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.white,
        ),
        iconSize: 24.0,
        dropdownColor: Color(0xff2b2a39),
        style: TextStyle(color: Colors.white),
        onChanged: (String newValue) {
          if(newValue == currentCourse) {
            return;
          }
          examList = examMap[newValue];
          currentCourse = newValue;
          setState(() {

          });
        },
        items: courseList.map<DropdownMenuItem<String>>((String value) {
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


  @override
  void initState() {
    Globals.currentPage = "examsScreen";
    _dataBloc = BlocProvider.of<DataBloc>(context);
    _dataBloc.getExamsData(Globals.currentUser.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: MenuDrawer(),
      backgroundColor: Colors.white,
      body: StreamBuilder(
          stream: _dataBloc.examsData,
          builder: (BuildContext context,
              AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              if (once) {
                once = false;
                examMap = snapshot.data[0];
                courseList = examMap.keys.toList();
                examList = examMap[courseList.first];
                currentCourse = courseList.first;
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
                    Container(
                      height: ResponsiveFlutter.of(context).verticalScale(44.5),
                      margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(24.0)),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
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
                    _courseDropDown(),
                    SizedBox(
                      height: ResponsiveFlutter.of(context).verticalScale(40),
                    ),
                    _examListWidget(),
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
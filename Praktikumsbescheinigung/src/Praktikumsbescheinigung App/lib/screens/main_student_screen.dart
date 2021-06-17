import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:studybuddy/blocs/bloc_provider.dart';
import 'package:studybuddy/blocs/data_bloc.dart';
import 'package:studybuddy/objects/course_object.dart';
import 'package:studybuddy/objects/event_object.dart';
import 'package:studybuddy/objects/semester_object.dart';
import 'package:studybuddy/objects/student_object.dart';
import 'package:studybuddy/screens/complete_attestation_screen.dart';
import 'package:studybuddy/screens/upload_file_screen.dart';
import 'package:studybuddy/services/database_service.dart';
import 'package:studybuddy/services/globals.dart';
import 'package:studybuddy/widgets/menu_button.dart';
import 'package:studybuddy/widgets/menu_drawer.dart';

import 'scan_qr_screen.dart';

class MainStudentScreen extends StatefulWidget {
  MainStudentScreen({
    Key key,
  }) : super(key: key);

  @override
  MainStudentScreenState createState() => MainStudentScreenState();
}

class MainStudentScreenState extends State<MainStudentScreen> {
  StudentObject currentUser;
  DatabaseService dbService = DatabaseService.instance;
  Map<CourseObject, Map<EventObject, String>> eventStatusMap;
  Map<CourseObject, Map<EventObject, String>> oldEventStatusMap;
  Map<EventObject, String> nextEventsMap;
  Map<SemesterObject, Map<int, int>> currentSemesterMap;

  DataBloc _dataBloc;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  Widget _eventStatusList() {
    return Container(
      height: ResponsiveFlutter.of(context).verticalScale(186.0),
      child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: eventStatusMap.values.length,
          itemBuilder: (context, index) {
            return _eventStatusRow(index);
          }),
    );
  }

  Widget _statusIcon(String status) {
    switch (status) {
      case "upload":
        return Icon(
          Icons.warning,
          color: Color(0xff19d9d3),
        );
        break;
      case "waiting":
        return Icon(
          Icons.chat,
          color: Color(0xff19d9d3),
        );
        break;
      case "failed":
        return Icon(
          Icons.info_outline,
          color: Color(0xffff7979),
        );
        break;
    }
    return Container();
  }

  Widget _statusColumn(String courseName, String status) {
    switch (status) {
      case "upload":
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              courseName,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                color: const Color(0xff19d9d3),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Dateiupload erforderlich.',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: ResponsiveFlutter.of(context).fontSize(1.4), //fontSize: 13
                color: const Color(0xfffefeff),
              ),
              textAlign: TextAlign.left,
            ),
          ],
        );
        break;
      case "waiting":
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              courseName,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                color: const Color(0xff19d9d3),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Testatanfrage wird überprüft.',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: ResponsiveFlutter.of(context).fontSize(1.4), //fontSize: 13
                color: const Color(0xfffefeff),
              ),
              textAlign: TextAlign.left,
            ),
          ],
        );
        break;
      case "failed":
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              courseName,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                color: const Color(0xff19d9d3),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Testatanfrage abgelehnt.',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: ResponsiveFlutter.of(context).fontSize(1.4), //fontSize: 13
                color: const Color(0xffff7979),
              ),
              textAlign: TextAlign.left,
            ),
          ],
        );
        break;
    }
    return Container();
  }

  Widget _eventStatusRow(int index) {
    CourseObject course = eventStatusMap.keys.toList()[index];
    EventObject event =
        eventStatusMap.values.toList()[index].keys.toList().first;
    String eventStatus =
        eventStatusMap.values.toList()[index].values.toList().first;
    bool isNew = false;
    if (Globals.oldEventStatusMap != null) {
      isNew = true;

        Globals.oldEventStatusMap.keys.forEach((element) {
          if(course.id == element.id) {
            Globals.oldEventStatusMap[element].forEach((key, value) {
              if(key.id == event.id && value == eventStatus) {
                isNew = false;
              }
            });
          }
        });
    }
    return Container(
      margin: EdgeInsets.fromLTRB(
          ResponsiveFlutter.of(context).scale(16.0),
          0.0,
          ResponsiveFlutter.of(context).scale(16.0),
          ResponsiveFlutter.of(context).verticalScale(8.0)
      ),
      height: ResponsiveFlutter.of(context).verticalScale(54.0),
      child: InkWell(
        onTap: () {
          if(Globals.oldEventStatusMap != null) {
            Globals.oldEventStatusMap.putIfAbsent(
                course, () => eventStatusMap.values.toList()[index]);
            setState(() {

            });
          }
          if (eventStatus != "failed") {
            Globals.currentCourse = course;
            Globals.currentEvent = event;
            Globals.fromOverview = true;
            String prevPage = Globals.currentPage;
            if (eventStatus == "none" || eventStatus == "upload") {
              Navigator.of(context)
                  .push(Globals.slideRight(UploadFileScreen()))
                  .then((value) {
                Globals.currentPage = prevPage;
              });
            } else {
              Navigator.of(context)
                  .push(Globals.slideRight(CompleteAttestationScreen()))
                  .then((value) {
                Globals.currentPage = prevPage;
              });
            }
          }
        },
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(
                  ResponsiveFlutter.of(context).scale(8.0), 0.0, 0.0, 0.0),
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                Container(
                  height: ResponsiveFlutter.of(context).verticalScale(64.0),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                      children: <Widget>[
                    Container(
                    height: ResponsiveFlutter.of(context).verticalScale(40.0),
                      width: ResponsiveFlutter.of(context).scale(40.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            ResponsiveFlutter.of(context).scale(10.0)),
                        border: Border.all(
                            width: ResponsiveFlutter.of(context).scale(2.0),
                            color: Colors.grey),
                        color: Color(0xff3f3d56),
                      ),
                      child: _statusIcon(eventStatus),
                    ),
                    isNew
                        ? Container(
                      margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(22.0), bottom: ResponsiveFlutter.of(context).verticalScale(38.0)),
                            height: ResponsiveFlutter.of(context)
                                .verticalScale(16.0),
                            width: ResponsiveFlutter.of(context).scale(32.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  ResponsiveFlutter.of(context).scale(16.0)),
                              color: Colors.redAccent,
                            ),
                      child: Center(
                        child: Text("NEU",
                        style: TextStyle(
                          fontSize: ResponsiveFlutter.of(context).fontSize(1.2), // fontSize: 12
                          fontFamily: "Nunito",
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      ),
                      ),
                          )
                        : Container(
                      margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(22.0), bottom: ResponsiveFlutter.of(context).verticalScale(38.0)),
                      height: ResponsiveFlutter.of(context)
                          .verticalScale(16.0),
                      width: ResponsiveFlutter.of(context).scale(32.0),
                    ),
                  ]),
                ),
                SizedBox(
                  width: ResponsiveFlutter.of(context).scale(4.0),
                ),
                _statusColumn(course.name, eventStatus)
              ]),
            ),
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(
                  right: ResponsiveFlutter.of(context).scale(8.0)),
              child: Icon(Icons.arrow_forward_ios, color: Color(0xfff7fafc)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nextEventsList() {
    return Expanded(
        child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: nextEventsMap.keys.length,
            itemBuilder: (context, index) {
              return _nextEventRow(index);
            })
    );
  }

  Widget _nextEventRow(int index) {
    String courseName = nextEventsMap.values.toList()[index];
    EventObject event = nextEventsMap.keys.toList()[index];
    String dateString = Globals.getDayOfEvent(event);
    return Container(
      margin: EdgeInsets.fromLTRB(
          ResponsiveFlutter.of(context).scale(16.0),
          0.0,
          ResponsiveFlutter.of(context).scale(16.0),
          ResponsiveFlutter.of(context).verticalScale(8.0)
      ),
      height: ResponsiveFlutter.of(context).verticalScale(48.0),
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(
                ResponsiveFlutter.of(context).scale(8.0), 0.0, 0.0, 0.0),
            child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      event.time.split('-').first,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: ResponsiveFlutter.of(context)
                            .fontSize(1.6), //fontSize: 14
                        color: const Color(0xff3f3d56),
                        letterSpacing: -0.28,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      event.time.split('-').last,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: ResponsiveFlutter.of(context)
                            .fontSize(1.6), //fontSize: 14
                        color: const Color(0xff00b1ac),
                        letterSpacing: -0.28,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ]),
              SizedBox(
                width: ResponsiveFlutter.of(context).scale(16.0),
              ),
              InkWell(
                  onTap: () {
                    String prevPage = Globals.currentPage;
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => ScanQrScreen()))
                        .then((value) {
                      Globals.currentPage = prevPage;
                    });
                  },
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          courseName,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: ResponsiveFlutter.of(context)
                                .fontSize(1.8), //fontSize: 15
                            color: const Color(0xff3f3d56),
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: ResponsiveFlutter.of(context)
                                  .fontSize(1.4), //fontSize: 13
                              color: const Color(0xff6a65a1),
                            ),
                            children: [
                              TextSpan(
                                text: '$dateString',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: ', ${event.date}',
                              ),
                            ],
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ])),
            ]),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(
                right: ResponsiveFlutter.of(context).scale(8.0)),
            child: IconButton(
                icon: Icon(Icons.calendar_today, color: Color(0xff6a65a1)),
                onPressed: () {
                  final Event calendarEvent = Event(
                    title: courseName,
                    description: event.name,
                    location: event.room,
                    startDate: DateTime.parse(
                        "${event.date.split(".").reversed.join("-")} ${event.time.split("-").first}"),
                    endDate: DateTime.parse(
                        "${event.date.split(".").reversed.join("-")} ${event.time.split("-").last}"),
                  );
                  Add2Calendar.addEvent2Cal(calendarEvent);
                }),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    Globals.currentPage = "mainStudentScreen";
    currentUser = Globals.currentUser;
    _dataBloc = BlocProvider.of<DataBloc>(context);
    _dataBloc.getMainStudentData(currentUser.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: MenuDrawer(),
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: _dataBloc.mainStudentData,
        builder: (
          BuildContext context,
          AsyncSnapshot<List<dynamic>> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            eventStatusMap = snapshot.data[0];
            if(Globals.oldEventStatusMap.isEmpty) {
              Globals.oldEventStatusMap.addAll(eventStatusMap);
            }
            nextEventsMap = snapshot.data[1];
            return Stack(
              children: <Widget>[
                Container(
                  height: ResponsiveFlutter.of(context).hp(51.5),
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
                        'Übersicht',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: ResponsiveFlutter.of(context).fontSize(4.0), //fontSize: 24
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: ResponsiveFlutter.of(context).verticalScale(16.0),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: ResponsiveFlutter.of(context).scale(24.0)),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Aktuelles',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: ResponsiveFlutter.of(context).fontSize(2.9), //fontSize: 20
                          color: const Color(0xff19d9d3),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: ResponsiveFlutter.of(context).verticalScale(16.0),
                    ),
                    eventStatusMap.isEmpty
                        ? Container(
                            height: ResponsiveFlutter.of(context)
                                .verticalScale(186.0),
                            child: Center(
                              child: Text(
                                'Zur Zeit gibt es keine aktuellen Benachrichtigungen.',
                                style: TextStyle(
                                  fontFamily: "Nunito",
                                  fontSize: ResponsiveFlutter.of(context)
                                      .fontSize(1.8), //fontSize: 15
                                  color: Color(0xff19d9d3),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          )
                        : _eventStatusList(),
                    SizedBox(
                        height:
                            ResponsiveFlutter.of(context).verticalScale(48.0)),
                    Container(
                      margin: EdgeInsets.only(
                          left: ResponsiveFlutter.of(context).scale(24.0)),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Nächste Termine',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: ResponsiveFlutter.of(context).fontSize(2.9), //fontSize: 20
                          color: const Color(0xff00b1ac),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      height: ResponsiveFlutter.of(context).verticalScale(16.0),
                    ),
                    nextEventsMap.isEmpty
                        ? Container(
                            height: ResponsiveFlutter.of(context)
                                .verticalScale(186.0),
                            child: Center(
                              child: Text(
                                'Zur Zeit stehen keine Termine an.',
                                style: TextStyle(
                                  fontFamily: "Nunito",
                                  fontSize: ResponsiveFlutter.of(context)
                                      .fontSize(1.8), //fontSize: 15
                                  color: Color(0xff3f3d56),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          )
                        : _nextEventsList(),
                  ],
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

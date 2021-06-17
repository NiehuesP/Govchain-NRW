import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:studybuddy/blocs/bloc_provider.dart';
import 'package:studybuddy/blocs/data_bloc.dart';
import 'package:studybuddy/objects/course_object.dart';
import 'package:studybuddy/objects/event_object.dart';
import 'package:studybuddy/objects/professor_object.dart';
import 'package:studybuddy/screens/generate_qr_screen.dart';
import 'package:studybuddy/screens/practicum_screen.dart';
import 'package:studybuddy/services/database_service.dart';
import 'package:studybuddy/services/globals.dart';
import 'package:studybuddy/widgets/menu_button.dart';
import 'package:studybuddy/widgets/menu_drawer.dart';

class MainProfessorScreen extends StatefulWidget {
  MainProfessorScreen({
    Key key,
  }) : super(key: key);

  @override
  MainProfessorScreenState createState() => MainProfessorScreenState();
}

class MainProfessorScreenState extends State<MainProfessorScreen> {
  ProfessorObject currentUser;
  DatabaseService dbService = DatabaseService.instance;
  Map<CourseObject, Map<EventObject, int>> eventStatusMap;
  Map<EventObject, String> nextEventsMap;
  DataBloc _dataBloc;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  Widget _eventStatusList() {
    return Container(
      //padding: EdgeInsets.zero,
      height: ResponsiveFlutter.of(context).verticalScale(124.0),
      child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: eventStatusMap.values.length,
          itemBuilder: (context, index) {
            return _eventStatusRow(index);
          }),
    );
  }


  Widget _statusColumn(String courseName, int requests) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            Row(
              children: <Widget> [
                Container(
                  height: ResponsiveFlutter.of(context).verticalScale(12.0),
                  width: ResponsiveFlutter.of(context).scale(24.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: Colors.redAccent,
                  ),
                  child: Center(
                    child: Text(
                    requests.toString(),
                    style: TextStyle(
                      fontFamily: 'Nunito',
                        fontSize: ResponsiveFlutter.of(context).fontSize(1.4), // fontSize: 13
                        color: Color(0xfffefeff),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  ),
                ),
                SizedBox(width: ResponsiveFlutter.of(context).scale(4.0),),
                Text(
                  'offene Testatanfragen.',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: ResponsiveFlutter.of(context).fontSize(1.4), //fontSize: 13
                    color: const Color(0xfffefeff),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            )
          ],
        );
  }

  Widget _eventStatusRow(int index) {
    CourseObject course = eventStatusMap.keys.toList()[index];
    EventObject event =
        eventStatusMap.values.toList()[index].keys
            .toList()
            .first;
    int eventRequests =
        eventStatusMap.values.toList()[index].values
            .toList()
            .first;
    return Container(
      margin: EdgeInsets.fromLTRB(ResponsiveFlutter.of(context).scale(16.0), 0.0, ResponsiveFlutter.of(context).scale(16.0), ResponsiveFlutter.of(context).verticalScale(8.0)),
      height: ResponsiveFlutter.of(context).verticalScale(54.0),
      child: InkWell(
        onTap: () {
            Globals.currentCourse = course;
            Globals.currentEvent = event;
            Globals.fromOverview = true;
            String prevPage = Globals.currentPage;
              Navigator.of(context)
                  .push(
                 Globals.slideRight(PracticumScreen(date: event.date)))
                  .then((value) {
                Globals.currentPage = prevPage;
              });
        },
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(ResponsiveFlutter.of(context).scale(8.0), 0.0, 0.0, 0.0),
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: ResponsiveFlutter.of(context).verticalScale(40.0),
                      width: ResponsiveFlutter.of(context).scale(40.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(10.0)),
                        border: Border.all(width: ResponsiveFlutter.of(context).scale(2.0), color: Colors.grey),
                        color: Color(0xff3f3d56),
                      ),

                      child: Icon(Icons.notifications_none, color: Color(0xff19d9d3),),
                    ),
                    SizedBox(width: ResponsiveFlutter.of(context).scale(16.0),),
                    _statusColumn(course.name, eventRequests)
                  ]
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(right: ResponsiveFlutter.of(context).scale(8.0)),
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
            }));
  }

  Widget _nextEventRow(int index) {
    String courseName = nextEventsMap.values.toList()[index];
    EventObject event = nextEventsMap.keys.toList()[index];
    String dateString = Globals.getDayOfEvent(event);
    return Container(
      margin: EdgeInsets.fromLTRB(ResponsiveFlutter.of(context).scale(16.0), 0.0, ResponsiveFlutter.of(context).scale(16.0), ResponsiveFlutter.of(context).verticalScale(8.0)),
      height: ResponsiveFlutter.of(context).verticalScale(48.0),
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(ResponsiveFlutter.of(context).scale(8.0), 0.0, 0.0, 0.0),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          event.time.split('-').first,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: ResponsiveFlutter.of(context).fontSize(1.6), //fontSize: 14
                            color: const Color(0xff3f3d56),
                            letterSpacing: -0.28,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          event.time.split('-').last,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: ResponsiveFlutter.of(context).fontSize(1.6), //fontSize: 14
                            color: const Color(0xff00b1ac),
                            letterSpacing: -0.28,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ]
                  ),
                  SizedBox(width: ResponsiveFlutter.of(context).scale(16.0),),
                  Expanded(
                      child: InkWell(
                      onTap: () {
                      },
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              courseName,
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                                color: const Color(0xff3f3d56),
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text.rich(
                              TextSpan(
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: ResponsiveFlutter.of(context).fontSize(1.4), //fontSize: 13
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
                          ]
                      )
                  ),
                  ),
                ]
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(right: ResponsiveFlutter.of(context).scale(8.0)),
            child: IconButton(
                icon: Icon(MdiIcons.qrcode,
                    color: Color(0xff6a65a1)),
                onPressed: () {
                  String prevPage = Globals.currentPage;
                  Navigator.of(context)
                      .push(
                      MaterialPageRoute(builder: (context) => GenerateQrScreen(event: event)))
                      .then((value) {
                    Globals.currentPage = prevPage;
                  });
                }
            ),
          ),
        ],
      ),
    );
  }


  @override
  void initState() {
    Globals.currentPage = "mainProfessorScreen";
    currentUser = Globals.currentUser;
    _dataBloc = BlocProvider.of<DataBloc>(context);
    _dataBloc.getMainProfessorData(currentUser.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: MenuDrawer(),
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: _dataBloc.mainProfessorData,
        builder: (BuildContext context,
            AsyncSnapshot<List<dynamic>> snapshot,) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            eventStatusMap = snapshot.data[0];
            nextEventsMap = snapshot.data[1];

            return Stack(
              children: <Widget>[
                Container(
                  height: ResponsiveFlutter.of(context).hp(42.5),
                  color: Color(0xff3f3d56),
                ),
                MenuButton(scaffoldKey: _scaffoldKey),
                Column(
                  children: <Widget>[
                    SizedBox(height: ResponsiveFlutter.of(context).verticalScale(32.0),),
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
                      margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(24.0)),
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
                    eventStatusMap.isEmpty ? Container(
                      height: ResponsiveFlutter.of(context).verticalScale(124.0),
                      child: Center(
                        child: Text(
                          'Zur Zeit gibt es keine aktuellen Benachrichtigungen.',
                          style: TextStyle(
                            fontFamily: "Nunito",
                            fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                            color: Color(0xff19d9d3),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ) : _eventStatusList(),
                    //_userCard(),
                    SizedBox(height: ResponsiveFlutter.of(context).verticalScale(48.0)),
                    Container(
                      margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(24.0)),
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
                    nextEventsMap.isEmpty ? Expanded(
                      child: Center(
                        child: Text(
                          'Zur Zeit stehen keine Termine an.',
                          style: TextStyle(
                            fontFamily: "Nunito",
                            fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                            color: Color(0xff3f3d56),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ) : _nextEventsList(),
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
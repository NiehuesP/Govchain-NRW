import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:studybuddy/blocs/bloc_provider.dart';
import 'package:studybuddy/blocs/data_bloc.dart';
import 'package:studybuddy/objects/calendar_event_object.dart';
import 'package:studybuddy/objects/course_object.dart';
import 'package:studybuddy/objects/event_object.dart';
import 'package:studybuddy/objects/professor_object.dart';
import 'package:studybuddy/screens/generate_qr_screen.dart';
import 'package:studybuddy/screens/practicum_detail_screen.dart';
import 'package:studybuddy/services/database_service.dart';
import 'package:studybuddy/services/globals.dart';
import 'package:studybuddy/widgets/menu_button.dart';
import 'package:studybuddy/widgets/menu_drawer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tuple/tuple.dart';


class PracticumScreen extends StatefulWidget {
  PracticumScreen({
    Key key, this.date,
  }) : super(key: key);

  final String date;

  @override
  _PracticumScreenState createState() =>
      _PracticumScreenState();
}

class _PracticumScreenState extends State<PracticumScreen> with TickerProviderStateMixin {
  ProfessorObject currentUser;
  DatabaseService dbService = DatabaseService.instance;
  Map<CourseObject, Map<EventObject, Tuple2<int, int>>> courseEventMap;
  EventObject nextEvent;
  DateTime _currentDate;
  String currentCourseName;
  CourseObject _currentCourse;
  bool once = true;
  CalendarEventObject _currentEvent;
  List<int> courseIds = [];
  int colorId = 0;
  DataBloc _dataBloc;


  Map<DateTime, List<CalendarEventObject>> _events = LinkedHashMap();
  AnimationController _animationController;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day) {
    print('CALLBACK: _onDaySelected');
    if(_events[day] != null) {
      _animationController.forward(from: 0.0);
      setState(() {
        _currentEvent = _events[day].first;
        _currentDate = _currentEvent.date;
        currentCourseName = _currentEvent.title;
        _currentCourse = _currentEvent.course;
      });
    }
  }

  void _onCalendarCreated(
      PageController pageController) {
    print('CALLBACK: _onCalendarCreated');
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    CalendarEventObject calendarEvent = events.first;
    if (calendarEvent.requests != 0 && _currentEvent != calendarEvent) {
      return Stack(
          children: <Widget> [
        AnimatedContainer(
        width: ResponsiveFlutter.of(context).scale(46.0),
        height: ResponsiveFlutter.of(context).verticalScale(46.0),
        alignment: Alignment.center,
        margin: const EdgeInsets.all(4.0),
        duration: const Duration(milliseconds: 300),
        child: Center(
          child: calendarEvent.getIcon(),
        ),
      ),
            Container(
              margin: EdgeInsets.only(top: ResponsiveFlutter.of(context).verticalScale(2.0), left: ResponsiveFlutter.of(context).scale(30.0)),
              child: Icon(Icons.notifications, color: Colors.white, size: ResponsiveFlutter.of(context).scale(12.0),),
            ),
          ]
      );
    } else if (_currentEvent != calendarEvent){
      return AnimatedContainer(
        width: ResponsiveFlutter.of(context).scale(46.0),
        height: ResponsiveFlutter.of(context).verticalScale(46.0),
        alignment: Alignment.center,
        margin: const EdgeInsets.all(4.0),
        duration: const Duration(milliseconds: 300),
        child: Center(
          child: calendarEvent.getIcon(),
        ),
      );
    } else if(calendarEvent.requests != 0){
      return Container(
        margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).verticalScale(31.0), left: ResponsiveFlutter.of(context).scale(27.0)),
        child: Icon(Icons.notifications, color: Colors.white, size: ResponsiveFlutter.of(context).scale(12.0)),
      );
    } else {
      return Container();
    }
  }

  List<CalendarEventObject> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  Widget _calendar() {
    return Container(
      height: ResponsiveFlutter.of(context).verticalScale(390.0),
      margin: EdgeInsets.fromLTRB(ResponsiveFlutter.of(context).scale(16.0), 0.0,ResponsiveFlutter.of(context).scale(16.0), 0.0),
      child: Column(
          children: <Widget> [
            TableCalendar(
              locale: 'de_DE',
              focusedDay: _currentDate,
              eventLoader: _getEventsForDay,
              firstDay: _events.keys.first,
              lastDay: _events.keys.last,
              calendarFormat: CalendarFormat.month,
              rowHeight: ResponsiveFlutter.of(context).verticalScale(46.0),
              rangeSelectionMode: RangeSelectionMode.disabled,
              selectedDayPredicate: (day) {
                return isSameDay(_currentDate, day);
              },
              //formatAnimation: FormatAnimation.slide,
              startingDayOfWeek: StartingDayOfWeek.monday,
              availableGestures: AvailableGestures.all,
              availableCalendarFormats: const {
                CalendarFormat.month: '',
                CalendarFormat.week: '',
              },
              calendarStyle: CalendarStyle(
                outsideDaysVisible: true,
                outsideTextStyle: TextStyle().copyWith(color: Color(0xff6a65a1)),
                defaultTextStyle: TextStyle().copyWith(color: Colors.white),
                weekendTextStyle: TextStyle().copyWith(color: Colors.white),
                selectedTextStyle: TextStyle().copyWith(color: Colors.white),
                todayTextStyle: TextStyle().copyWith(color: Colors.white),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle().copyWith(color: Color(0xff6a65a1)),
                weekendStyle: TextStyle().copyWith(color: Color(0xff6a65a1)),
              ),
              headerStyle: HeaderStyle(
                leftChevronIcon: Icon(Icons.arrow_back_ios, color: Colors.white),
                rightChevronIcon: Icon(Icons.arrow_forward_ios, color: Colors.white),
                //centerHeaderTitle: true,
                formatButtonVisible: false,
                titleTextStyle: TextStyle(
                  color: Colors.white,
                    fontSize: ResponsiveFlutter.of(context).fontSize(3.2),
                    //fontSize: 22
                    fontFamily: "Nunito"
                ),
              ),
              calendarBuilders: CalendarBuilders(
                selectedBuilder: (context, date, _) {
                  return FadeTransition(
                    opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Color(0xff6a65a1),
                      ),
                      width: 100,
                      height: 100,
                      child: Text(
                        '${date.day}',
                        style: TextStyle().copyWith(fontSize: 16.0, color: Colors.white),
                      ),
                    ),
                  );
                },
                todayBuilder: (context, date, _) {
                  return Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          width: 2.0,
                          color: const Color(0xff6a65a1)),
                    ),
                    width: 100,
                    height: 100,
                    child: Text(
                      '${date.day}',
                      style: TextStyle().copyWith(fontSize: 16.0, color: Colors.white),
                    ),
                  );
                },
                markerBuilder: (context, date, events) {

                  if (events.isNotEmpty) {
                      return _buildEventsMarker(date, events);
                  }

                  return null;
                },
              ),
              onDaySelected: (selectedDay, focusedDay) {
                _onDaySelected(selectedDay);
              },
              onCalendarCreated: _onCalendarCreated,
            ),
            SizedBox(height: ResponsiveFlutter.of(context).verticalScale(8.0),),
            Expanded(
              //height: ResponsiveFlutter.of(context).verticalScale(40.0),
            child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: courseIds.length,
            //physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              Color color;
              switch(index) {
                case 0:
                  color = Colors.green;
                  break;
                case 1:
                  color = Colors.amberAccent;
                  break;
                case 2:
                  color = Color(0xff00b1ac);
                  break;
                case 3:
                  color = Colors.deepPurpleAccent;
                  break;
                case 4:
                  color = Colors.redAccent;
                  break;
                case 5:
                  color = Colors.blueAccent;
                  break;
                case 6:
                  color = Colors.brown;
                  break;
                case 7:
                  color = Colors.orangeAccent;
                  break;
                case 8:
                  color = Colors.purpleAccent;
                  break;
              }
              String courseName;
              for(CourseObject course in courseEventMap.keys) {
                if(course.id == courseIds[index]) {
                  courseName = course.name;
                  break;
                }
              }
              return Row(
                children: <Widget> [
                SizedBox(width: ResponsiveFlutter.of(context).scale(24.0),),
                Container(
                  height: ResponsiveFlutter.of(context).verticalScale(8.0),
                  width: ResponsiveFlutter.of(context).scale(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(4.0)),
                    color: color,
                  ),
                ),
                SizedBox(width: ResponsiveFlutter.of(context).scale(4.0),),
                Text(courseName,
                  style: TextStyle(
                    fontFamily: "Nunito",
                    color: Colors.white,
                  ),
                ),
              ]
              );
            }),
            ),
            SizedBox(height: ResponsiveFlutter.of(context).verticalScale(10.0),)
          ]
      ),
    );
  }

  @override
  void initState() {
    currentUser = Globals.currentUser;
    Globals.currentPage = "practicumScreen";
    _dataBloc = BlocProvider.of<DataBloc>(context);
    _dataBloc.getPracticumData(Globals.currentUser.id);
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  _dateIcon(int day, int courseId) {
    Color color;
    if(!courseIds.contains(courseId)) {
      courseIds.add(courseId);
      colorId++;
    }
    switch (colorId) {
      case 1:
        color = Colors.green;
        break;
      case 2:
        color = Colors.amberAccent;
        break;
      case 3:
        color = Color(0xff00b1ac);
        break;
      case 4:
        color = Colors.deepPurpleAccent;
        break;
      case 5:
        color = Colors.redAccent;
        break;
      case 6:
        color = Colors.blueAccent;
        break;
      case 7:
        color = Colors.brown;
        break;
      case 8:
        color = Colors.orangeAccent;
        break;
      case 9:
        color = Colors.purpleAccent;
        break;
    }
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Center(
        child: Text(
          day.toString(),
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _eventCard() {
    EventObject event = _currentEvent.event;
    int requests = _currentEvent.requests;
    int participants = _currentEvent.participants;
    return Expanded(
        child: Center(
        child: Container(
      margin: EdgeInsets.fromLTRB(ResponsiveFlutter.of(context).scale(24.0), 0.0, ResponsiveFlutter.of(context).scale(24.0), 0.0),
      height: ResponsiveFlutter.of(context).verticalScale(62.0),
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Row(children: <Widget>[
                InkWell(
                  onTap: () {
    String prevPage = Globals.currentPage;
    Navigator.of(context)
        .push(
    MaterialPageRoute(builder: (context) => GenerateQrScreen(event: event)))
        .then((value) {
      Globals.currentPage = prevPage;
    });
                  },
              child: Container(
                  height: ResponsiveFlutter.of(context).verticalScale(40.0),
                  width: ResponsiveFlutter.of(context).scale(40.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(10.0)),
                    border: Border.all(width: ResponsiveFlutter.of(context).scale(2.0), color: Color(0xff6a65a1)),
                    //color: Color(0xff3f3d56),
                  ),

                  child: Icon(MdiIcons.qrcode, color: Color(0xff6a65a1),),
                ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
      String prevPage = Globals.currentPage;
      Navigator.of(context)
          .push(
          Globals.slideRight(PracticumDetailScreen(event: event, course: _currentCourse)))
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
                            "$requests offene Anfragen",
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
                            "$participants Teilnehmer",
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
                              "Raum ${event.room}",
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: ResponsiveFlutter.of(context).fontSize(1.4), //fontSize: 13
                                color: const Color(0xff6a65a1),
                              ),
                              textAlign: TextAlign.left,
                            )),

                      ]),
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
    ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: MenuDrawer(),
      backgroundColor: Colors.white,
      body: StreamBuilder(
          stream: _dataBloc.practicumData,
          builder: (BuildContext context,
              AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              if(snapshot.data[0] != courseEventMap) {
                courseEventMap = snapshot.data[0];
                _events.clear();
                courseIds.clear();
                colorId = 0;
                DateTime givenDate;
                if (widget.date != null) {
                  givenDate = DateTime.parse(widget.date
                      .split(".")
                      .reversed
                      .join("-"));
                  givenDate = givenDate.toUtc();
                }
                courseEventMap.forEach((course, value) {
                  value.forEach((event, tuple) {
                    DateTime current = DateTime.parse(
                        event.date
                            .split(".")
                            .reversed
                            .join("-"));
                    current = current.toUtc();
                    CalendarEventObject dateEvent = CalendarEventObject(
                        date: current,
                        event: event,
                        course: course,
                        title: course.name,
                        icon: _dateIcon(current.day, event.courseId),
                        requests: tuple.item1,
                        participants: tuple.item2);
                    if(_events[current] == null) {
                      _events.putIfAbsent(current, () => [dateEvent]);
                    } else {
                      _events[current].add(dateEvent);
                    }
                    if (givenDate == null) {
                      _currentDate = current;
                      _currentEvent = dateEvent;
                      currentCourseName = course.name;
                      _currentCourse = course;
                    } else if (current == givenDate) {
                      _currentDate = current;
                      _currentEvent = dateEvent;
                      currentCourseName = course.name;
                      _currentCourse = course;
                    }
                  });
                });
              }
              return Stack(
                children: <Widget>[
                  Container(
                    height: ResponsiveFlutter.of(context).hp(80.5),
                    color: Color(0xff3f3d56),
                  ),
                  MenuButton(scaffoldKey: _scaffoldKey),
                  Column(
                    children: <Widget>[
                      SizedBox(
                          height: ResponsiveFlutter.of(context)
                              .verticalScale(32.0)),

                        Container(
                          height: ResponsiveFlutter.of(context).verticalScale(44.5),
                          margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(24.0)),
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Praktikum',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: ResponsiveFlutter.of(context)
                                  .fontSize(4.0), //fontSize: 24
                              color: const Color(0xffffffff),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      SizedBox(
                        height:
                        ResponsiveFlutter.of(context).verticalScale(16.0),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: ResponsiveFlutter.of(context).scale(24.0)),
                        alignment: Alignment.topLeft,
                        child: Text(
                          currentCourseName,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: ResponsiveFlutter.of(context)
                                .fontSize(2.9), //fontSize: 20
                            color: const Color(0xff19d9d3),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(
                        height:
                        ResponsiveFlutter.of(context).verticalScale(16.0),
                      ),

                      Container(
                          child: Container(
                            height: ResponsiveFlutter.of(context).verticalScale(404),
                            child: _calendar(),
                          )
                      ),
                      SizedBox(height: ResponsiveFlutter.of(context).verticalScale(6.0),),
                      _eventCard()
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
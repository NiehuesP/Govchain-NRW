import 'dart:collection';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:studybuddy/objects/calendar_event_object.dart';
import 'package:studybuddy/objects/course_object.dart';
import 'package:studybuddy/objects/course_progress_object.dart';
import 'package:studybuddy/objects/event_object.dart';
import 'package:studybuddy/objects/event_progress_object.dart';
import 'package:studybuddy/objects/student_object.dart';
import 'package:studybuddy/screens/complete_attestation_screen.dart';
import 'package:studybuddy/screens/upload_file_screen.dart';
import 'package:studybuddy/services/database_service.dart';
import 'package:studybuddy/services/globals.dart';
import 'package:studybuddy/services/web_service.dart';
import 'package:studybuddy/widgets/custom_back_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:studybuddy/widgets/menu_button.dart';
import 'package:studybuddy/widgets/menu_drawer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:studybuddy/services/blockchain_service.dart';

class AttestationDetailScreen extends StatefulWidget {
  AttestationDetailScreen({
    Key key,
    this.course,
    this.courseProgress,
  }) : super(key: key);

  final CourseObject course;
  final CourseProgressObject courseProgress;

  @override
  _AttestationDetailScreenState createState() =>
      _AttestationDetailScreenState();
}

class _AttestationDetailScreenState extends State<AttestationDetailScreen> with TickerProviderStateMixin {
  WebService webService = WebService.instance;
  CourseObject currentCourse;
  CourseProgressObject currentCourseProgress;
  StudentObject currentUser;
  DatabaseService dbService = DatabaseService.instance;
  BlockchainService blockchain = BlockchainService.instance;
  Map<EventObject, EventProgressObject> eventMap;
  Future<Map<EventObject, EventProgressObject>> _future;
  EventObject nextEvent;
  bool _showCalendar = false;
  DateTime _currentDate;
  DateTime _focusedDate;
  bool once = true;
  List<Widget> pages = [];
  int _current = 0;
  String _prevPage;
  CalendarEventObject _currentEvent;
  Map<DateTime, List<CalendarEventObject>>_events = LinkedHashMap();
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
          _focusedDate = _currentEvent.date;
      });
    }
  }

  void _onCalendarCreated(
      PageController pageController) {
    print('CALLBACK: _onCalendarCreated');
  }

  List<CalendarEventObject> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    CalendarEventObject calendarEvent = events.first;

    if (_currentEvent == calendarEvent) {
      Color color;
      if (calendarEvent.eventProgress.status == "failed") {
        color = Colors.redAccent;
      } else if (calendarEvent.eventProgress.status == "completed") {
        color = Colors.green;
      } else if (calendarEvent.eventProgress.status == "none") {
        color = Colors.transparent;
      } else {
        color = Colors.amberAccent;
      }
      return Container(
        margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).verticalScale(30.5), left: ResponsiveFlutter.of(context).scale(28.5)),
        height: ResponsiveFlutter.of(context).verticalScale(12.0),
        width: ResponsiveFlutter.of(context).scale(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(16.0)),
          color: color,
        ),
      );
    } else {
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
    }
  }

  Widget _calendar() {
    return Container(
      margin: EdgeInsets.fromLTRB(ResponsiveFlutter.of(context).scale(16.0), 0.0,ResponsiveFlutter.of(context).scale(16.0), 0.0),
      height: ResponsiveFlutter.of(context).verticalScale(370.0),
      child: Column(
      children: <Widget> [
        TableCalendar(
          locale: 'de_DE',
          eventLoader: _getEventsForDay,
          firstDay: _events.keys.first,
          lastDay: _events.keys.last,
          calendarFormat: CalendarFormat.month,
          focusedDay: _focusedDate,
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
        Row(
          children: <Widget>[
            SizedBox(width: ResponsiveFlutter.of(context).scale(8.0),),
            Container(
              height: ResponsiveFlutter.of(context).verticalScale(8.0),
              width: ResponsiveFlutter.of(context).scale(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(4.0)),
                color: Colors.green,
              ),
            ),
            SizedBox(width: ResponsiveFlutter.of(context).scale(4.0),),
            Text("bestanden",
              style: TextStyle(
                fontFamily: "Nunito",
                color: Colors.white,
              ),
            ),
            SizedBox(width: ResponsiveFlutter.of(context).scale(16.0),),
            Container(
              height: ResponsiveFlutter.of(context).verticalScale(8.0),
              width: ResponsiveFlutter.of(context).scale(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(4.0)),
                color: Colors.amberAccent,
              ),
            ),
            SizedBox(width: ResponsiveFlutter.of(context).scale(4.0),),
            Text("ausstehend",
              style: TextStyle(
                fontFamily: "Nunito",
                color: Colors.white,
              ),
            ),
            SizedBox(width: ResponsiveFlutter.of(context).scale(16.0),),
            Container(
              height: ResponsiveFlutter.of(context).verticalScale(8.0),
              width: ResponsiveFlutter.of(context).scale(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(4.0)),
                color: Colors.redAccent,
              ),
            ),
            SizedBox(width: ResponsiveFlutter.of(context).scale(4.0),),
            Text("nicht bestanden",
              style: TextStyle(
                fontFamily: "Nunito",
                color: Colors.white,
              ),
            ),
          ],
        ),
    ]
      ),
    );
  }

  Widget _courseCompleted() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Sie haben das \nPraktikum bestanden!',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: ResponsiveFlutter.of(context).fontSize(3.2), //fontSize: 22
              color: const Color(0xfffefeff),
            ),
            textAlign: TextAlign.center,
          ),
          SvgPicture.string(
            _svg_sdwih3,
            allowDrawingOutsideViewBox: true,
          ),
          Text(
            'Laden Sie das Testat als überprüfbares PDF-Dokument herunter, um Ihre Teilnahme gegenüber Dritten nachzuweisen.',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: ResponsiveFlutter.of(context).fontSize(2.0), //fontSize: 17
              color: const Color(0xfffefeff),
            ),
            textAlign: TextAlign.center,
          ),
      Text.rich(
        TextSpan(
          style: TextStyle(
            fontFamily: 'Nunito',
            color: Colors.white,
          ),
          children: [
            TextSpan(
              text: "Testat erhalten\n",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.green,
              ),
            ),
            TextSpan(
              text: "${currentCourseProgress.completedDate?.split('-')?.reversed?.join('.')} | ${currentCourseProgress.completedTime} Uhr",
              style: TextStyle(
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
        ],
      ),
    );
  }

  getData() {
    _future = dbService.getEventMapForCourse(currentUser.id, currentCourse.id);
  }

  @override
  void initState() {
    _prevPage = Globals.currentPage;
    currentCourse = widget.course;
    currentUser = Globals.currentUser;
    currentCourseProgress = widget.courseProgress;
    Globals.currentPage = "attestationDetailScreen";
    if (!currentCourseProgress.completed) {
      _showCalendar = true;
    }
    getData();
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  _dateIcon(int day, String status) {
    Color color;
    if (status == "failed") {
      color = Colors.redAccent;
    } else if (status == "completed") {
      color = Colors.green;
    } else if (status == "none") {
      color = Color(0xff2b2a39);
    } else {
      color = Colors.amberAccent;
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
    EventProgressObject eventProgress = _currentEvent.eventProgress;
    String header;
    IconData icon;
    switch (eventProgress.status) {
      case "completed":
        header = "Praktikum bestanden";
        icon = Icons.check;
        break;
      case "failed":
        header = "Praktikum nicht bestanden";
        icon = Icons.info_outline;
        break;
      case "waiting":
        header = "Dateien werden überprüft";
        icon = Icons.chat;
        break;
      case "upload":
        header = "Dateiupload erforderlich";
        icon = Icons.warning;
        break;
      case "none":
        header = "Teilnahme wird überprüft";
        icon = Icons.help_outline;
        break;
    }
    return Expanded(
        child: Center(
        child:Container(
      margin: EdgeInsets.fromLTRB(ResponsiveFlutter.of(context).scale(16.0), 0.0, ResponsiveFlutter.of(context).scale(16.0), 0.0),
      height: ResponsiveFlutter.of(context).verticalScale(62.0),
      child: InkWell(
        onTap: () async {
          String prevPage = Globals.currentPage;
          Globals.currentEvent = event;
          if(eventProgress.status == "upload") {
            Globals.fromOverview = true;
            Navigator.of(context).push(Globals.slideRight(UploadFileScreen())).then((value) {
              Globals.currentPage = prevPage;
            });
          } else if(eventProgress.status == "waiting" || eventProgress.status == "completed") {
            Navigator.of(context).push(Globals.slideRight(CompleteAttestationScreen())).then((value) {
              Globals.currentPage = prevPage;
            });
          }
        },
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

                  child: Icon(icon, color: Color(0xff6a65a1),),
                ),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(8.0), right: ResponsiveFlutter.of(context).scale(24.0)),
                          child: Text(
                            header,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                              color: const Color(0xff3f3d56),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        eventProgress.status == "completed" ? Container(
                          margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(8.0), right: ResponsiveFlutter.of(context).scale(24.0)),
                          child: Text(
                            "${eventProgress.completedDate} ${eventProgress.completedTime}",
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: ResponsiveFlutter.of(context).fontSize(1.4), //fontSize: 13
                              color: const Color(0xff6a65a1),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ) : Container(),
                        Container(
                          margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(8.0), right: ResponsiveFlutter.of(context).scale(24.0)),
                          child: Text(
                            eventProgress.status == "completed" ? "${eventProgress.professorName}" : "${currentCourseProgress.professorName}",
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
        ),
    );
  }

  void _showAlertDialog(int courseId, int studentId, String fileName) async {
    final String dir = (await getExternalStorageDirectory()).path;
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Testat herunterladen"),
          content: Text("Wollen Sie das Testat $fileName herunterladen? \n\nDieses wird unter $dir/Downloads/Testate/${currentUser.fhIdentifier}/$fileName gespeichert."),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Abbrechen")),
            TextButton(
                onPressed: () async {
                  await webService.downloadCertificate(courseId, studentId, currentUser.fhIdentifier, fileName);
                  Navigator.of(context).pop();
                },
                child: Text("Herunterladen")),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: MenuDrawer(
        prevPage: _prevPage,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: _future,
          builder: (BuildContext context,
              AsyncSnapshot<Map<EventObject, EventProgressObject>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              eventMap = snapshot.data;
              if (once) {
                once = false;
                DateTime prev;
                eventMap.forEach((event, value) {
                  if (value.status != "completed") {
                    DateTime current = DateTime.parse(
                        event.date.split(".").reversed.join("-"));
                    current = current.toUtc();
                    CalendarEventObject dateEvent = CalendarEventObject(
                        date: current,
                        event: event,
                        icon: _dateIcon(current.day, value.status),
                        eventProgress: value);
                    if(_events[current] == null) {
                      _events.putIfAbsent(current, () => [dateEvent]);
                    } else {
                      _events[current].add(dateEvent);
                    }
                    if (prev == null) {
                      prev = current;
                      _currentDate = current;
                      _currentEvent = dateEvent;
                      _focusedDate = _currentDate;
                      nextEvent = event;
                    } else if (current.isBefore(prev)) {
                      prev = current;
                      _currentDate = current;
                      _currentEvent = dateEvent;
                      _focusedDate = _currentDate;
                      nextEvent = event;
                    }
                  } else {
                    DateTime current = DateTime.parse(
                        event.date.split(".").reversed.join("-"));
                    current = current.toUtc();
                    CalendarEventObject dateEvent = CalendarEventObject(
                        date: current,
                        event: event,
                        icon: _dateIcon(current.day, value.status),
                        eventProgress: value);
                    if(_events[current] == null) {
                      _events.putIfAbsent(current, () => [dateEvent]);
                    } else {
                      _events[current].add(dateEvent);
                    }
                    _currentDate = current;
                    _currentEvent = dateEvent;
                    _focusedDate = _currentDate;
                  }
                });
              }
              if(!_showCalendar) {
                pages.clear();
                pages.add(_courseCompleted());
                pages.add(_calendar());
              }
              return Stack(
                children: <Widget>[
                  Container(
                    height: ResponsiveFlutter.of(context).hp(_current == 0 && currentCourseProgress.completed ? 100.0 : 82.0), //82
                    color: Color(0xff3f3d56),
                  ),
                  MenuButton(scaffoldKey: _scaffoldKey),
                  Column(
                    children: <Widget>[
                      SizedBox(
                          height: ResponsiveFlutter.of(context)
                              .verticalScale(32.0)),
                      Row(children: <Widget>[
                        CustomBackButton(),
                        Container(
                          padding: EdgeInsets.zero,
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Testate',
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
                      ]),
                      SizedBox(
                        height:
                            ResponsiveFlutter.of(context).verticalScale(16.0),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: ResponsiveFlutter.of(context).scale(24.0)),
                        alignment: Alignment.topLeft,
                        child: Text(
                          currentCourse.name,
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
                      currentCourseProgress.completed
                          ? Container(
                              child: Column(
                                children: <Widget>[
                                  CarouselSlider(
                                    items: pages,
                                    options: CarouselOptions(
                                        height: ResponsiveFlutter.of(context).verticalScale(372.0),
                                        autoPlay: false,
                                        enlargeCenterPage: false,
                                        viewportFraction: 1,
                                        initialPage: 0,
                                        enableInfiniteScroll: false,
                                        onPageChanged: (index, reason) {
                                          setState(() {
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
                                  SizedBox(
                                    height: ResponsiveFlutter.of(context).verticalScale(4.0),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              child: Container(
                                height: ResponsiveFlutter.of(context).verticalScale(408),
                              child: _calendar(),
                              )
                            ),
                      SizedBox(height: ResponsiveFlutter.of(context).verticalScale(6.0),),
                      currentCourseProgress.completed ? Container(
            child: _current == 0 ? Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget> [
            Container(
                        height: ResponsiveFlutter.of(context).verticalScale(48.0),
                        width: ResponsiveFlutter.of(context).wp(86.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                          padding: EdgeInsets.all(0.0),
            ),
                          onPressed: () {
                            _showAlertDialog(currentCourse.id, currentUser.id, "${currentCourse.name.replaceAll(RegExp(r"\s+"), "_").replaceAll(r".", "_")}.pdf");
                          },
                          child: Text(
                            'Testat als PDF herunterladen',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: ResponsiveFlutter.of(context).fontSize(2.0), //fontSize: 17
                              color: const Color(0xffffffff),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              ResponsiveFlutter.of(context).scale(6.0)),
                          color: Color(0xff00b1ac),
                        ),
                      ),
            ]
            ),
                      ) :  _eventCard(),
                      ) : _eventCard(),
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

const String _svg_sdwih3 =
    '<svg viewBox="133.6 362.7 107.9 107.9" ><path transform="translate(5284.0, -515.35)" d="M -5080.05859375 931.8507690429688 L -5080.05859375 931.8505249023438 L -5095.404296875 931.8505249023438 L -5055.353515625 892.0340576171875 L -5047.79833984375 899.5904541015625 L -5080.05859375 931.8505249023438 L -5080.05859375 931.8507690429688 Z M -5108.2080078125 931.8505249023438 L -5108.21044921875 931.8505249023438 L -5123.48779296875 931.8505249023438 L -5126.06201171875 929.2764282226563 L -5118.50537109375 921.7200317382813 L -5108.2099609375 931.8488159179688 L -5108.2080078125 931.8505249023438 Z M -5150.35009765625 931.8505249023438 C -5150.33349609375 924.609130859375 -5148.888671875 917.572998046875 -5146.056640625 910.9367065429688 C -5143.3212890625 904.5284423828125 -5139.41748046875 898.7677612304688 -5134.45361328125 893.8145751953125 C -5129.48876953125 888.8603515625 -5123.71923828125 884.96875 -5117.3056640625 882.2479858398438 C -5110.6611328125 879.4295654296875 -5103.619140625 878.00048828125 -5096.37451171875 878.00048828125 C -5092.74755859375 878.00048828125 -5089.20654296875 878.3408813476563 -5085.849609375 879.01220703125 C -5082.4921875 879.6835327148438 -5079.2236328125 880.7051391601563 -5076.134765625 882.0485229492188 L -5084.5 890.4151000976563 C -5088.26416015625 889.3400268554688 -5092.2587890625 888.7947998046875 -5096.37451171875 888.7947998046875 C -5120.11572265625 888.7947998046875 -5139.48583984375 908.1095581054688 -5139.55419921875 931.8505249023438 L -5139.55615234375 931.8505249023438 L -5139.55615234375 931.8495483398438 L -5150.35009765625 931.8505249023438 Z" fill="#19d9d3" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(5284.0, -556.0)" d="M -5096.37451171875 1026.600341796875 C -5103.62890625 1026.600341796875 -5110.68017578125 1025.167358398438 -5117.33251953125 1022.341247558594 C -5123.75341796875 1019.613464355469 -5129.5283203125 1015.711853027344 -5134.4951171875 1010.744873046875 C -5139.4619140625 1005.778259277344 -5143.36328125 1000.00390625 -5146.09130859375 993.582275390625 C -5148.9169921875 986.9296875 -5150.35009765625 979.8786010742188 -5150.35009765625 972.6248779296875 L -5150.35009765625 972.4993896484375 L -5139.55419921875 972.4993896484375 C -5139.5546875 972.5414428710938 -5139.5546875 972.5828247070313 -5139.5546875 972.6248779296875 C -5139.5546875 996.4342651367188 -5120.18408203125 1015.8046875 -5096.37451171875 1015.8046875 C -5072.56494140625 1015.8046875 -5053.19482421875 996.4342651367188 -5053.19482421875 972.6248779296875 L -5042.400390625 972.6248779296875 C -5042.400390625 979.879638671875 -5043.83349609375 986.930419921875 -5046.6591796875 993.582275390625 C -5049.38720703125 1000.003845214844 -5053.28857421875 1005.778137207031 -5058.25537109375 1010.744873046875 C -5063.2216796875 1015.711608886719 -5068.99560546875 1019.613159179688 -5075.4169921875 1022.341247558594 C -5082.0693359375 1025.167358398438 -5089.1201171875 1026.600341796875 -5096.37451171875 1026.600341796875 Z M -5101.7724609375 994.2147827148438 L -5101.77294921875 994.214111328125 L -5123.4892578125 972.4993896484375 L -5108.208984375 972.4993896484375 L -5101.7724609375 978.8314819335938 L -5095.4033203125 972.4993896484375 L -5080.05712890625 972.4993896484375 L -5101.77197265625 994.214111328125 L -5101.7724609375 994.2147827148438 Z" fill="#19d9d3" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';

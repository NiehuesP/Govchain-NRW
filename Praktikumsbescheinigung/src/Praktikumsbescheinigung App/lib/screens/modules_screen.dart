
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:studybuddy/blocs/bloc_provider.dart';
import 'package:studybuddy/blocs/data_bloc.dart';

import 'package:studybuddy/objects/event_settings_object.dart';
import 'package:studybuddy/services/database_service.dart';
import 'package:studybuddy/services/globals.dart';
import 'package:studybuddy/services/web_service.dart';
import 'package:studybuddy/widgets/menu_button.dart';
import 'package:studybuddy/widgets/menu_drawer.dart';

class ModulesScreen extends StatefulWidget {
  ModulesScreen({
    Key key,
  }) : super(key: key);

  _ModulesScreenState createState() => _ModulesScreenState();
}

class _ModulesScreenState extends State<ModulesScreen> {
  DatabaseService dbService = DatabaseService.instance;
  WebService webService = WebService.instance;
  DataBloc _dataBloc;
  Map<String, Map<String, EventSettingsObject>> eventSettingsMap;
  List<String> courseList;
  List<String> eventList = [];
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  String currentCourse;
  String currentEvent;
  bool needUpload;
  bool autoComplete;
  bool notifications;
  String prevCourse;
  String prevEvent;
  bool prevNeedUpload;
  bool prevAutoComplete;
  bool prevNotifications;

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
          currentCourse = newValue;
          eventList.clear();
          eventList.add("Auf alle Termine anwenden");
          eventList.addAll(eventSettingsMap[currentCourse].keys);
          currentEvent = eventList.first;
          needUpload = true;
          autoComplete = false;
          notifications = false;
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

  Widget _eventDropDown() {
    return Container(
      margin: EdgeInsets.fromLTRB(ResponsiveFlutter.of(context).scale(16.0), 0.0, ResponsiveFlutter.of(context).scale(16.0), 0.0),
      width: ResponsiveFlutter.of(context).wp(86),
      padding: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(8.0), right: ResponsiveFlutter.of(context).scale(4.0)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).scale(4.0),),
        border: Border.all(width: ResponsiveFlutter.of(context).scale(2.0), color: Color(0xff2b2a39)),
        color: Colors.white,
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        underline: Container(
          color: Colors.transparent,
        ),
        value: currentEvent,
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: Color(0xff2b2a39),
        ),
        iconSize: 24.0,
        //dropdownColor: Color(0xff2b2a39),
        style: TextStyle(color: Color(0xff2b2a39)),
        onChanged: (String newValue) {
          if(newValue == currentEvent) {
            return;
          }
          currentEvent = newValue;
          if(eventSettingsMap[currentCourse].containsKey(currentEvent)) {
            EventSettingsObject eventSettingsObject = eventSettingsMap[currentCourse][currentEvent];
            needUpload = eventSettingsObject.needUpload;
            autoComplete = eventSettingsObject.autoComplete;
            notifications = eventSettingsObject.notifications;
          } else {
            needUpload = true;
            autoComplete = false;
            notifications = false;
          }
          setState(() {

          });
        },
        items: eventList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: ResponsiveFlutter.of(context).fontSize(1.8), //fontSize: 15
                color: Color(0xff2b2a39),
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
    Globals.currentPage = "modulesScreen";
    _dataBloc = BlocProvider.of<DataBloc>(context);
    _dataBloc.getModuleData(Globals.currentUser.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: MenuDrawer(),
      backgroundColor: Colors.white,
      body: StreamBuilder(
          stream: _dataBloc.moduleData,
          builder: (BuildContext context,
              AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              if (snapshot.data[0] != eventSettingsMap) {
                eventSettingsMap = snapshot.data[0];
                courseList = eventSettingsMap.keys.toList();
                if(prevCourse == null) {
                  currentCourse = courseList.first;
                } else {
                  currentCourse = prevCourse;
                  prevCourse = null;
                }
                eventList.clear();
                eventList.add("Auf alle Termine anwenden");
                eventList.addAll(eventSettingsMap[currentCourse].keys);
                if(prevEvent == null) {
                  currentEvent = eventList.first;
                  needUpload = true;
                  autoComplete = false;
                  notifications = false;
                } else {
                  currentEvent = prevEvent;
                  prevEvent = null;
                  needUpload = prevNeedUpload;
                  autoComplete = prevAutoComplete;
                  notifications = prevNotifications;
                }
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
                        'Module',
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
                        height: ResponsiveFlutter.of(context).verticalScale(32),
                      ),
                    Container(
                      margin: EdgeInsets.only(
                          left: ResponsiveFlutter.of(context).scale(24.0)),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Einstellungen',
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
                      _eventDropDown(),
                    SizedBox(
                      height: ResponsiveFlutter.of(context).verticalScale(16.0),
                    ),
                    Expanded(
            child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(24.0), right: ResponsiveFlutter.of(context).scale(24.0)),
                            child: Row(
                              children: <Widget>[
                                Switch(
                                  value: needUpload,
                                  onChanged: (value) {
                                    needUpload = value;
                                    if(needUpload == true) {
                                      autoComplete = false;
                                    }
                                    setState(() {

                                    });
                                  },
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Dateiupload erforderlich',
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 15,
                                          color: const Color(0xff3f3d56),
                                          fontWeight: FontWeight.w700,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        'Student/-innen werden dazu aufgefordert eine Abgabe hochzuladen.',
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 13,
                                          color: const Color(0xff6a65a1),
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveFlutter.of(context).verticalScale(16.0),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(24.0), right: ResponsiveFlutter.of(context).scale(24.0)),
                            child: Row(
                              children: <Widget>[
                                Switch(
                                  value: needUpload ? false : autoComplete,
                                  onChanged: needUpload ? null : (value) {
                                    autoComplete = value;
                                    setState(() {

                                    });
                                  },
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Automatische Testatvergabe',
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 15,
                                          color: needUpload ? Colors.grey : Color(0xff3f3d56),
                                          fontWeight: FontWeight.w700,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        'Student/-innen erhalten automatisch das Testat, wenn sie ihre Teilnahme nachgewiesen haben (nur möglich, \nwenn kein Dateiupload erforderlich ist).',
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 13,
                                          color: needUpload ? Colors.grey : Color(0xff6a65a1),
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: ResponsiveFlutter.of(context).verticalScale(16.0),),
                          Container(
                            margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).scale(24.0), right: ResponsiveFlutter.of(context).scale(24.0)),
                            child: Row(
                              children: <Widget>[
                                Switch(
                                  value: notifications,
                                  onChanged: (value) {
                                    notifications = value;
                                    setState(() {

                                    });
                                  },
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Benachrichtigungen',
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 15,
                                          color: const Color(0xff3f3d56),
                                          fontWeight: FontWeight.w700,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        'Sie erhalten Benachrichtigungen, wenn Student/-innen Ihnen eine Testatanfrage senden. ',
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 13,
                                          color: const Color(0xff6a65a1),
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ),
                    SizedBox(height: ResponsiveFlutter.of(context).verticalScale(16.0),),
                    Container(
                      height: ResponsiveFlutter.of(context).verticalScale(48.0),
                      width: ResponsiveFlutter.of(context).wp(86),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(0.0),
            ),
                          onPressed: () {
                            if(currentEvent == "Auf alle Termine anwenden") {
                              eventSettingsMap[currentCourse].forEach((key, value) {
                                value.needUpload = needUpload;
                                value.autoComplete = autoComplete;
                                value.notifications = notifications;
                                webService.updateEventSettings(value);
                              });
                            }  else {
                              EventSettingsObject eventSettings = eventSettingsMap[currentCourse][currentEvent];
                              eventSettings.needUpload = needUpload;
                              eventSettings.autoComplete = autoComplete;
                              eventSettings.notifications = notifications;
                              webService.updateEventSettings(eventSettings);
                            }
                            prevCourse = currentCourse;
                            prevEvent = currentEvent;
                            prevNeedUpload = needUpload;
                            prevAutoComplete = autoComplete;
                            prevNotifications = notifications;
                          },
                          child: Text(
                            'Auswahl anwenden',
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
                    SizedBox(height: ResponsiveFlutter.of(context).verticalScale(32.0),),
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
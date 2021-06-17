import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:studybuddy/objects/course_object.dart';
import 'package:studybuddy/objects/event_object.dart';
import 'package:studybuddy/objects/semester_object.dart';
import 'package:intl/intl.dart';

class Globals {
  static bool isLoggedIn = false;
  static var currentUser;
  static int completedCourses;
  static int totalCourses;
  static CourseObject currentCourse;
  static EventObject currentEvent;
  static SemesterObject currentSemester;
  static bool fromOverview = false;
  static String currentPage = "";

  static Map<CourseObject, Map<EventObject, String>> oldEventStatusMap = LinkedHashMap();

  static final Random _random = Random.secure();

  static String createCryptoRandomString([int length = 32]) {
    var values = List<int>.generate(length, (i) => _random.nextInt(256));

    return base64Url.encode(values);
  }

  static getDayOfEvent(EventObject event) {
    DateTime day = DateTime.parse(event.date.split('.').reversed.join('-'));
    String dateString;
    if (day.day == DateTime.now().day && day.month == DateTime.now().month && day.year == DateTime.now().year) {
      dateString = 'Heute';
    } else {
      dateString = DateFormat('EEEE').format(day);
      switch (dateString) {
        case "Monday":
          dateString = "Montag";
          break;
        case "Tuesday":
          dateString = "Dienstag";
          break;
        case "Wednesday":
          dateString = "Mittwoch";
          break;
        case "Thursday":
          dateString = "Donnerstag";
          break;
        case "Friday":
          dateString = "Freitag";
          break;
        case "Saturday":
          dateString = "Samstag";
          break;
        case "Sunday":
          dateString = "Sonntag";
          break;
      }
    }
    return dateString;
  }

  static Route slideRight(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  static Route slideLeft(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}

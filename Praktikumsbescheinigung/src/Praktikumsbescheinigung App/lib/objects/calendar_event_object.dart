import 'package:flutter/material.dart';
import 'package:studybuddy/objects/course_object.dart';
import 'package:studybuddy/objects/event_object.dart';
import 'package:studybuddy/objects/event_progress_object.dart';

class CalendarEventObject {
  final int id;
  final DateTime date;
  final String title;
  final Widget icon;
  final Widget dot;
  final EventObject event;
  final CourseObject course;
  EventProgressObject eventProgress;
  int requests;
  int participants;

  CalendarEventObject({
    this.id,
    this.date,
    this.title,
    this.icon,
    this.dot,
    this.event,
    this.course,
    this.eventProgress,
    this.requests,
    this.participants,
  }) : assert(date != null);


  @override
  bool operator ==(dynamic other) {
    return this.id == other.id &&
      this.date == other.date &&
        this.title == other.title &&
        this.icon == other.icon &&
        this.dot == other.dot &&
        this.event == other.event &&
        this.course == other.course &&
        this.eventProgress == other.eventProgress &&
        this.requests == other.requests &&
        this.participants == other.participants;
  }

  int get hashCode => hashValues(date, title, icon);

  DateTime getDate() {
    return date;
  }

  Widget getDot() {
    return dot;
  }

  Widget getIcon() {
    return icon;
  }

  String getTitle() {
    return title;
  }

  EventObject getEvent() {
    return event;
  }

  CourseObject getCourse() {
    return course;
  }

  EventProgressObject getEventProgress() {
    return eventProgress;
  }

  int getRequests() {
    return requests;
  }

  int getParticipants() {
    return participants;
  }

  int getId() {
    return id;
  }
}
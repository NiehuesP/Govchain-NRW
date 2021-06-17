
import 'exam_object.dart';

class ExamDataObject {

  int examId;
  int courseId;
  String date;
  String time;
  String room;
  int professorId;
  int enrolledCount;
  int approvedCount;

  ExamDataObject.withId(
      this.examId,
      this.courseId,
      this.date,
      this.time,
      this.room,
      this.professorId,
      this.enrolledCount,
      this.approvedCount,
      );

  ExamDataObject(
      this.courseId,
      this.date,
      this.time,
      this.room,
      this.professorId,
      this.enrolledCount,
      this.approvedCount,
      );

  Map<String, dynamic> toMap() => {
    "examId": examId,
    "courseId": courseId,
    "date": date?.split('.')?.reversed?.join('-'),
    "time": time,
    "room": room,
    "professorId": professorId,
    "enrolledCount": enrolledCount,
    "approvedCount": approvedCount,
  };

  ExamDataObject.fromMapObject(Map<String, dynamic> map) {
    this.examId = map['examId'];
    this.courseId = map['courseId'];
    this.date = map['date']?.split('-')?.reversed?.join('.');
    this.time = map['time'];
    this.room = map['room'];
    this.professorId = map['professorId'];
    this.enrolledCount = map['enrolledCount'];
    this.approvedCount = map['approvedCount'];
  }

  ExamDataObject.fromExamObject(ExamObject exam) {
    this.examId = exam.examId;
    this.courseId = exam.courseId;
    this.date = exam.date;
    this.time = exam.time;
    this.room = exam.room;
    this.professorId = exam.professorId;
  }
}
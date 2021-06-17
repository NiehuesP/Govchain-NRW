
class ExamObject {

  int examId;
  int courseId;
  String date;
  String time;
  String room;
  int professorId;

  ExamObject.withId(
      this.examId,
      this.courseId,
      this.date,
      this.time,
      this.room,
      this.professorId,
      );

  ExamObject(
      this.courseId,
      this.date,
      this.time,
      this.room,
      this.professorId,
      );

  Map<String, dynamic> toMap() => {
    "examId": examId,
    "courseId": courseId,
    "date": date?.split('.')?.reversed?.join('-'),
    "time": time,
    "room": room,
    "professorId": professorId,
  };

  ExamObject.fromMapObject(Map<String, dynamic> map) {
    this.examId = map['examId'];
    this.courseId = map['courseId'];
    this.date = map['date']?.split('-')?.reversed?.join('.');
    this.time = map['time'];
    this.room = map['room'];
    this.professorId = map['professorId'];
  }
}
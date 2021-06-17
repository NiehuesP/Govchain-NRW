
class StudentCourseObject {

  int studentId;
  int courseId;
  String completed;
  String date;
  String time;
  int professorId;
  int semesterId;

  StudentCourseObject(
      this.studentId,
      this.courseId,
      this.completed,
      this.date,
      this.time,
      this.professorId,
      this.semesterId,
      );

  Map<String, dynamic> toMap() => {
    "studentId": studentId,
    "courseId": courseId,
    "completed": completed,
    "date": date?.split('.')?.reversed?.join('-'),
    "time": time,
    "professorId": professorId,
    "semesterId": semesterId,
  };

  StudentCourseObject.fromMapObject(Map<String, dynamic> map) {
    this.studentId = map['studentId'];
    this.courseId = map['courseId'];
    this.completed = map['completed'];
    this.date = map['date']?.split('-')?.reversed?.join('.');
    this.time = map['time'];
    this.professorId = map['professorId'];
    this.semesterId = map['semesterId'];
  }
}

class StudentEventObject {

  int studentId;
  int eventId;
  int professorId;
  String date;
  String time;
  String status;

  StudentEventObject(
      this.studentId,
      this.eventId,
      this.professorId,
      this.date,
      this.time,
      this.status,
      );

  Map<String, dynamic> toMap() => {
    "studentId": studentId,
    "eventId": eventId,
    "professorId": professorId,
    "date": date?.split('.')?.reversed?.join('-'),
    "time": time,
    "status": status,
  };

  StudentEventObject.fromMapObject(Map<String, dynamic> map) {
    this.studentId = map['studentId'];
    this.eventId = map['eventId'];
    this.professorId = map['professorId'];
    this.date = map['date']?.split('-')?.reversed?.join('.');
    this.time = map['time'];
    this.status = map['status'];
  }
}
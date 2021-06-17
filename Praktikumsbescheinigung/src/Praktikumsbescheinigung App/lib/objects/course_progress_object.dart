class CourseProgressObject {
  bool completed;
  String semesterName;
  String professorName;
  String completedDate;
  String completedTime;
  int completedEvents;
  int totalEvents;

  CourseProgressObject(this.completed,
      this.semesterName,
      this.professorName,
      this.completedDate,
      this.completedTime,
      this.completedEvents,
      this.totalEvents,);

  Map<String, dynamic> toMap() => {
    "completed": completed,
    "semesterName": semesterName,
    "professorName": professorName,
    "completedDate": completedDate?.split('.')?.reversed?.join('-'),
    "completedTime": completedTime,
    "completedEvents": completedEvents,
    "totalEvents": totalEvents,
  };

  CourseProgressObject.fromMapObject(Map<String, dynamic> map) {
    this.completed = map['completed'];
    this.semesterName = map['semesterName'];
    this.professorName = map['professorName'];
    this.completedDate = map['completedDate']?.split('-')?.reversed?.join('.');
    this.completedTime = map['completedTime'];
    this.completedEvents = map['completedEvents'];
    this.totalEvents = map['totalEvents'];
  }
}
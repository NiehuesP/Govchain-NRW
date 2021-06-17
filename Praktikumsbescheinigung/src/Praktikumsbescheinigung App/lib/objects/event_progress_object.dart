class EventProgressObject {
  String status;
  String professorName;
  String completedDate;
  String completedTime;


  EventProgressObject(this.status,
      this.professorName,
      this.completedDate,
      this.completedTime,);

  Map<String, dynamic> toMap() => {
    "status": status,
    "professorName": professorName,
    "completedDate": completedDate,
    "completedTime": completedTime,
  };

  EventProgressObject.fromMapObject(Map<String, dynamic> map) {
    this.status = map['status'];
    this.professorName = map['professorName'];
    this.completedDate = map['completedDate'];
    this.completedTime = map['completedTime'];
  }
}
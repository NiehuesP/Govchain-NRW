
class EventObject {

  int id;
  String date;
  String name;
  String room;
  String time;
  int courseId;

  EventObject.withId(
      this.id,
      this.date,
      this.name,
      this.room,
      this.time,
      this.courseId,
      );

  EventObject(
      this.date,
      this.name,
      this.room,
      this.time,
      this.courseId,
      );

  Map<String, dynamic> toMap() => {
    "eventId": id,
    "date": date?.split('.')?.reversed?.join('-'),
    "name": name,
    "room": room,
    "time": time,
    "courseId": courseId,
  };

  EventObject.fromMapObject(Map<String, dynamic> map) {
    this.id = map['eventId'];
    this.date = map['date']?.split('-')?.reversed?.join('.');
    this.name = map['name'];
    this.room = map['room'];
    this.time = map['time'];
    this.courseId = map['courseId'];
  }
}
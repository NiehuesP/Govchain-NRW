
class CourseObject {
  int id;
  String name;
  String shortName;
  int semesterId;
  int professorId;

  CourseObject.withId(
    this.id,
    this.name,
    this.shortName,
    this.semesterId,
    this.professorId,
   );

  CourseObject(
    this.name,
    this.shortName,
    this.semesterId,
    this.professorId,
   );

  Map<String, dynamic> toMap() => {
    "courseId": id,
    "name": name,
    "shortName": shortName,
    "semesterId": semesterId,
    "professorId": professorId,
  };

  CourseObject.fromMapObject(Map<String, dynamic> map) {
    this.id = map['courseId'];
    this.name = map['name'];
    this.shortName = map['shortName'];
    this.semesterId = map['semesterId'];
    this.professorId = map['professorId'];
  }
}
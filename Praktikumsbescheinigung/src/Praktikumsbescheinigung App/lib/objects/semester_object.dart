
class SemesterObject {

  int id;
  String name;
  String startDate;
  String endDate;

  SemesterObject.withId(
      this.id,
      this.name,
      this.startDate,
      this.endDate,
      );

  SemesterObject(
      this.name,
      this.startDate,
      this.endDate,
      );

  Map<String, dynamic> toMap() => {
    "semesterId": id,
    "name": name,
    "startDate": startDate?.split('.')?.reversed?.join('-'),
    "endDate": endDate?.split('.')?.reversed?.join('-'),
  };

  SemesterObject.fromMapObject(Map<String, dynamic> map) {
    this.id = map['semesterId'];
    this.name = map['name'];
    this.startDate = map['startDate']?.split('-')?.reversed?.join('.');
    this.endDate = map['endDate']?.split('-')?.reversed?.join('.');
  }
}
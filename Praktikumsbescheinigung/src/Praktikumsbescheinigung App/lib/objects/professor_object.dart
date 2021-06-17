
class ProfessorObject {

  int id;
  String firstName;
  String lastName;
  String title;
  String fhIdentifier;
  String password;

  ProfessorObject.withId(
      this.id,
      this.firstName,
      this.lastName,
      this.title,
      this.fhIdentifier,
      this.password,
      );

  ProfessorObject(
      this.firstName,
      this.lastName,
      this.title,
      this.fhIdentifier,
      this.password,
      );

  Map<String, dynamic> toMap() => {
    "professorId": id,
    "firstName": firstName,
    "lastName": lastName,
    "title": title,
    "fhIdentifier": fhIdentifier,
    "password": password,
  };

  ProfessorObject.fromMapObject(Map<String, dynamic> map) {
    this.id = map['professorId'];
    this.firstName = map['firstName'];
    this.lastName = map['lastName'];
    this.title = map['title'];
    this.fhIdentifier = map['fhIdentifier'];
    this.password = map['password'];
  }
}
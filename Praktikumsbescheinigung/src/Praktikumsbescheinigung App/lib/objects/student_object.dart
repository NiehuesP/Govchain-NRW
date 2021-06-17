
class StudentObject {
  int id;
  String firstName;
  String lastName;
  int matriculation;
  String dateOfBirth;
  String university;
  String faculty;
  String field;
  String degree;
  String fhIdentifier;
  String password;

  StudentObject.withId(
    this.id,
    this.firstName,
    this.lastName,
    this.matriculation,
    this.dateOfBirth,
    this.university,
    this.faculty,
    this.field,
    this.degree,
    this.fhIdentifier,
    this.password,
  );

  StudentObject(
    this.firstName,
    this.lastName,
    this.matriculation,
    this.dateOfBirth,
    this.university,
    this.faculty,
    this.field,
    this.degree,
    this.fhIdentifier,
    this.password,
  );

  Map<String, dynamic> toMap() => {
    "studentId": id,
    "firstName": firstName,
    "lastName": lastName,
    "matriculation": matriculation,
    "dateOfBirth": dateOfBirth?.split('.')?.reversed?.join('-'),
    "university": university,
    "faculty": faculty,
    "field": field,
    "degree": degree,
    "fhIdentifier": fhIdentifier,
    "password": password,
  };

  StudentObject.fromMapObject(Map<String, dynamic> map) {
    this.id = map['studentId'];
    this.firstName = map['firstName'];
    this.lastName = map['lastName'];
    this.matriculation = map['matriculation'];
    this.dateOfBirth = map['dateOfBirth']?.split('-')?.reversed?.join('.');
    this.university = map['university'];
    this.faculty = map['faculty'];
    this.field = map['field'];
    this.degree = map['degree'];
    this.fhIdentifier = map['fhIdentifier'];
    this.password = map['password'];
  }
}
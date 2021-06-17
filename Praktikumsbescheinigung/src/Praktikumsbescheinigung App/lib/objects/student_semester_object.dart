
class StudentSemesterObject {

  int studentId;
  int semesterId;

  StudentSemesterObject(
      this.studentId,
      this.semesterId,
      );

  Map<String, dynamic> toMap() => {
    "studentId": studentId,
    "semesterId": semesterId,
  };

  StudentSemesterObject.fromMapObject(Map<String, dynamic> map) {
    this.studentId = map['studentId'];
    this.semesterId = map['semesterId'];
  }
}
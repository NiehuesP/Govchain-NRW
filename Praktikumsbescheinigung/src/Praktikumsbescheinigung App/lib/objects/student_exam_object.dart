
class StudentExamObject {

  int studentId;
  int examId;
  String status;

  StudentExamObject(
      this.studentId,
      this.examId,
      this.status,
      );

  Map<String, dynamic> toMap() => {
    "studentId": studentId,
    "examId": examId,
    "status": status,
  };

  StudentExamObject.fromMapObject(Map<String, dynamic> map) {
    this.studentId = map['studentId'];
    this.examId = map['examId'];
    this.status = map['status'];
  }
}
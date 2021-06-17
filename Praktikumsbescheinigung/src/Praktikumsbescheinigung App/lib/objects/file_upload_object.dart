
class FileUploadObject {

  int id;
  int eventId;
  int studentId;
  String fileName;
  String uploadTime;
  String fileType;
  int size;

  FileUploadObject.withId(
      this.id,
      this.eventId,
      this.studentId,
      this.fileName,
      this.uploadTime,
      this.fileType,
      this.size,
      );

  FileUploadObject(
      this.eventId,
      this.studentId,
      this.fileName,
      this.uploadTime,
      this.fileType,
      this.size,
      );

  Map<String, dynamic> toMap() => {
    "fileId": id,
    "eventId": eventId,
    "studentId": studentId,
    "fileName": fileName,
    "uploadTime": uploadTime,
    "fileType": fileType,
    "size": size,
  };

  FileUploadObject.fromMapObject(Map<String, dynamic> map) {
    this.id = map['fileId'];
    this.eventId = map['eventId'];
    this.studentId = map['studentId'];
    this.fileName = map['fileName'];
    this.uploadTime = map['uploadTime'];
    this.fileType = map['fileType'];
    this.size = map['size'];
  }
}
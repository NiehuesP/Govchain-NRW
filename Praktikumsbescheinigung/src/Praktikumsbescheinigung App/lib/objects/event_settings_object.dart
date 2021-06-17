
class EventSettingsObject {

  int eventId;
  int professorId;
  bool needUpload;
  bool autoComplete;
  bool notifications;

  EventSettingsObject(
      this.eventId,
      this.professorId,
      this.needUpload,
      this.autoComplete,
      this.notifications,
      );

  Map<String, dynamic> toMap() => {
    "eventId": eventId,
    "professorId": professorId,
    "needUpload": needUpload.toString(),
    "autoComplete": autoComplete.toString(),
    "notifications": notifications.toString(),
  };

  EventSettingsObject.fromMapObject(Map<String, dynamic> map) {
    this.eventId = map['eventId'];
    this.professorId = map['professorId'];
    this.needUpload = map['needUpload'] == "true";
    this.autoComplete = map['autoComplete'] == "true";
    this.notifications = map['notifications'] == "true";
  }
}
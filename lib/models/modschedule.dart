class Schedule {
  String time;
  String subject;
  String lecture;
  String room;

  Schedule({this.time, this.subject, this.lecture, this.room});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
        time: json['jam'],
        subject: json['makul'],
        lecture: json['dosen'],
        room: json['ruang']);
  }
}
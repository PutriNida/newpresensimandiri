class Subjects {
  String day;
  String time;
  String subject;
  String lecture;
  String room;

  Subjects({this.day, this.time, this.subject, this.lecture, this.room});

  factory Subjects.fromJson(Map<String, dynamic> json) {
    return Subjects(
        day: json['hari'],
        time: json['jam'],
        subject: json['makul'],
        lecture: json['dosen'],
        room: json['ruang']);
  }
}

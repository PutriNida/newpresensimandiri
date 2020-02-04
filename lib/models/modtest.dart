class TestAll {
  String subject;
  String day;
  String date;
  String time;
  String room;

  TestAll({this.subject, this.day, this.date, this.time, this.room});

  factory TestAll.fromJson(Map<String, dynamic> json) {
    return TestAll(
        subject: json['makul'],
        day: json['hari'],
        date: json['tanggal'],
        time: json['jam'],
        room: json['kode']);
  }
}

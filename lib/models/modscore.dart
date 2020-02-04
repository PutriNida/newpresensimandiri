class Scores {
  String subject;
  String presence;
  String finalscore;
  String credit;
  String task1;
  String task2;
  String task3;
  String task4;
  String midtest;
  String lasttest;

  Scores(
      {this.subject,
      this.presence,
      this.finalscore,
      this.credit,
      this.task1,
      this.task2,
      this.task3,
      this.task4,
      this.midtest,
      this.lasttest});

  factory Scores.fromJson(Map<String, dynamic> json) {
    return Scores(
        subject: json['makul'],
        presence: json['hadir'],
        finalscore: json['akhir'],
        credit: json['kredit'],
        task1: json['tgs'],
        task2: json['tgs2'],
        task3: json['tgs3'],
        task4: json['tgs4'],
        midtest: json['mid'],
        lasttest: json['uas']);
  }
}

class Result {
  bool error;
  String message;
  Mhs mahasiswa;

  Result({this.error, this.message, this.mahasiswa});

  factory Result.fromJson(Map<String, dynamic> parsedJson) {
    return Result(
        error: parsedJson['error'],
        message: parsedJson['message'],
        mahasiswa: Mhs.fromJson(parsedJson['mhs']));
  }
}

class Mhs {
  String username;
  String nama;
  String mreg;

  Mhs({this.username, this.nama, this.mreg});

  factory Mhs.fromJson(Map<String, dynamic> json) {
    return Mhs(
        username: json['nim'],
        nama: json['nama'],
        mreg: json['mreg']);
  }
}
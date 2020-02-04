import 'package:flutter/cupertino.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:newpresensimandiri/utils/utils.dart';
import 'package:newpresensimandiri/views/about.dart';

class IntroScreen extends StatefulWidget{
  @override
  IntroScreenState createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "SCAN QR CODE",
        description: "Pastikan anda masuk di kelas yang benar dan memiliki akses internet",
        pathImage: "assets/logo.png",
        backgroundColor: Color(0xff33ccff),
      ),
    );
    slides.add(
      new Slide(
        title: "",
        description: "Tekan tombol seperti gambar diatas untuk masuk ke halaman scan",
        pathImage: "assets/fotoprofil.png",
        backgroundColor: Color(0xff33ccff),
      ),
    );
    slides.add(
      new Slide(
        title: "",
        description:
        "Arahkan kamera ke QR Code yang ditampilkan oleh dosen anda",
        pathImage: "assets/ist.png",
        backgroundColor: Color(0xff33ccff),
      ),
    );
    slides.add(
      new Slide(
        title: "",
        description:
        "Apabila sudah terbaca dan tampil seperti gambar tersebut, kemudian klik OK",
        pathImage: "assets/ist.png",
        backgroundColor: Color(0xff33ccff),
      ),
    );
    slides.add(
      new Slide(
        title: "",
        description:
        "Data kehadiran akan tersimpan dan tunggu sampai pesan berhasil muncul",
        pathImage: "assets/ist.png",
        backgroundColor: Color(0xff33ccff),
      ),
    );
    slides.add(
      new Slide(
        title: "",
        description:
        "Apabila belum berhasil silahkan coba lagi atau presensi menggunakan komputer dosen secara manual",
        pathImage: "assets/ist.png",
        backgroundColor: Color(0xff33ccff),
      ),
    );
    slides.add(
      new Slide(
        title: "",
        description:
        "Silahkan kirim pertanyaan atau keluhan atau komentar anda terkain aplikasi ini dengan menggunakan fitur HUBUNGI KAMI",
        pathImage: "assets/ist.png",
        backgroundColor: Color(0xff33ccff),
      ),
    );
    slides.add(
      new Slide(
        title: "",
        description:
        "TERIMA KASIH TELAH MENGGUNAKAN FITUR INI",
        pathImage: "assets/ist.png",
        backgroundColor: Color(0xff33ccff),
      ),
    );
  }

  void onDonePress(BuildContext cont) {
    Utils().backAction(AboutPage(), cont);
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      slides: this.slides,
      onDonePress: () {onDonePress(context);},
    );
  }
}


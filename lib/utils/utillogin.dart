import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newpresensimandiri/login.dart';
import 'package:newpresensimandiri/main.dart';
import 'package:newpresensimandiri/utils/utils.dart';
import 'package:newpresensimandiri/utils/utilsettings.dart';
import 'package:newpresensimandiri/views/completedata.dart';

class UtilLogin {
  String email;
  String values;
  String number;
  String birthday,
      birthplace,
      gender,
      nik,
      religion,
      citizenship,
      address,
      district,
      province,
      postal_code,
      mother;

  void forgetPassword(BuildContext cont) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        sendEmailForget(cont);
      },
    );

    Widget cancelButton = FlatButton(
      child: Text("Batal"),
      onPressed: () {
        Navigator.of(cont).pop();
      },
    );
    AlertDialog input = AlertDialog(
      title: Text("Masukkan NIM dan E-Mail"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              autofocus: true,
              decoration:
              InputDecoration(labelText: "NIM", hintText: "cont. 191351001"),
              keyboardType: TextInputType.number,
              maxLength: 9,
              onChanged: (value) {
                number = value;
              },
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: "E-Mail", hintText: "cont. example@gmail.com"),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                email = value;
              },
            )
          ],
        ),
      ),
      actions: <Widget>[cancelButton, okButton],
    );
    showDialog(
      context: cont,
      builder: (BuildContext context) {
        return input;
      },
    );
  }

  void sendEmailForget(BuildContext cont) async {
    Utils().toast("Kirim E-Mail");
    Navigator.of(cont).pop();
    final response = await http.post(
        "https://api.akprind.ac.id/presensimandiri/apiflutter/apilainnya.php?apicall=kirimpassword",
        body: {"nim": number, "email": email});
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      Utils().toast(jsonData["message"]);
    } else {
      Utils().toast("Gagal Terhubung Ke Server");
    }
  }

  alertEmail(BuildContext cont, String uname, String forTiltle, String forLabel,
      String forHint) {
    Widget okButton = FlatButton(
      child: Text("Simpan"),
      onPressed: () {
        if (forLabel == "E-Mail")
          sendEmail(cont, uname);
        else
          sendNik(cont, uname);
      },
    );

    Widget cancelButton = FlatButton(
      child: Text("Batal"),
      onPressed: () {
        MyHomePage().signout();
        Navigator.push(
            cont, MaterialPageRoute(builder: (context) => LoginPage()));
      },
    );
    AlertDialog input = AlertDialog(
      title: Text(forTiltle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: forLabel, hintText: forHint),
            onChanged: (value) {
              values = value;
            },
          )
        ],
      ),
      actions: <Widget>[cancelButton, okButton],
    );
    showDialog(
      context: cont,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return input;
      },
    );
  }

  void checkEmail(BuildContext cont, String uname) async {
    final response = await http.get(
        "https://api.akprind.ac.id/presensimandiri/apiflutter/apilainnya.php?apicall=cekemail&nim=$uname");
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData["error"]) {
        alertEmail(cont, uname, "Masukkan E-Mail", "E-Mail",
            "cont. example@akprind.ac.id");
      } else {
        checkNumber(cont, uname);
      }
    } else {
      Utils().toast("Gagal Terhubung Ke Server");
    }
  }

  void sendEmail(BuildContext cont, String uname) async {
    Utils().toast("Kirim E-Mail");
    final response = await http.post(
        "https://api.akprind.ac.id/presensimandiri/apiflutter/apilainnya.php?apicall=ubahemail",
        body: {"nim": uname, "email": values});
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData["error"]) {
        Utils().toast(jsonData["message"]);
        MyHomePage().signout();
      } else {
        Utils().toast(jsonData["message"]);
        checkNumber(cont, uname);
      }
    } else {
      Utils().toast("Gagal Terhubung Ke Server");
    }
  }

  void checkNumber(BuildContext cont, String uname) async {
    final response = await http.get(
        "https://api.akprind.ac.id/presensimandiri/apiflutter/apilainnya.php?apicall=ceknik&nim=$uname");
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData["error"]) {
        alertEmail(
            cont, uname, "Masukkan NIK", "NIK", "cont. 3341123451420000");
      } else {
        Utils().toast(jsonData["message"]);
//        UtilSetting().showNotificationdaily(cont, uname);
        MyHomePage();
      }
    } else {
      Utils().toast("Gagal Terhubung Ke Server");
    }
  }

  void sendNik(BuildContext cont, String uname) async {
    Utils().toast("Kirim NIK");
    final response = await http.post(
        "https://api.akprind.ac.id/presensimandiri/apiflutter/apilainnya.php?apicall=ubahnik",
        body: {"nim": uname, "nik": values});
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData["error"]) {
        Utils().toast(jsonData["message"]);
        MyHomePage().signout();
      } else {
        Utils().toast(jsonData["message"]);
//        UtilSetting().showNotification(cont, uname);
        MyHomePage();
      }
    } else {
      Utils().toast("Gagal Terhubung Ke Server");
    }
  }

  void checkData(BuildContext cont, String uname) async {
    final response = await http.get(
        "https://api.akprind.ac.id/presensimandiri/apiflutter/apiprofil.php?nim=$uname");
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if(jsonData["status"]){
        if (!jsonData["lengkap"]) {
          Utils().toast(jsonData["message"]);
          birthday = jsonData["tgllahir"];
          birthplace = jsonData["tmptlahir"];
          gender = jsonData["jk"];
          nik = jsonData["nik"];
          religion = jsonData["agm"];
          citizenship = jsonData["wn"];
          address = jsonData["alamat"];
          district = jsonData["kab"];
          province = jsonData["prop"];
          postal_code = jsonData["kodepos"];
          mother = jsonData["ortu"];
          email = jsonData["email"];
          Utils().backAction(CompletingPage(), cont);
        } else {
          Utils().backAction(MyHomePage(), cont);
        }}
//      }else {
//        Utils().backAction(MyHomePage(), cont);
//      }
    } else {
      Utils().toast("Gagal Terhubung Ke Server");
    }
  }

  void completingData(BuildContext context, String number, String birthday, String birthplace, String gender, String nik, String religion,
      String citizenship, String address, String postal_code, String mother, String email) async {
    bool boy = true;
    if (gender == 'Perempuan') boy = false;
    Utils().toast('Data Dikirim');
    final response = await http.post(
        "https://api.akprind.ac.id/presensimandiri/apiflutter/apiubahprofil.php",
        body: {"nim": number, "tgllahir": birthday, "tmptlahir": birthplace, "jk": boy,
          "nik": nik, "agm": religion, "wn": citizenship, "alamat": address, "kodepos": postal_code, "ortu": mother, "email": email});
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (!jsonData["status"]) {
        Utils().toast(jsonData["message"]);
        Utils().backAction(MyHomePage(), context);
      } else {
        Utils().toast(jsonData["message"]);
        MyHomePage().signout();
      }
    } else {
      Utils().toast("Gagal Terhubung Ke Server");
    }
  }
}

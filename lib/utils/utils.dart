import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Utils {
  String status;

  void toast(String message) {

    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white);
  }

  checkLainnya(double _longitude, double _latitude, String ipaddress) {
    if (_longitude == null || _latitude == null)
      status = 'Lokasi tidak ditemukan';
    if (ipaddress == null) status = 'Ip tidak ditemukan';
    if (ipaddress != null && _longitude != null && _latitude != null) {
      status = 'Lengkap';
    }
  }

  sendPresence(String number, String classid, BuildContext cont,
      double _longitude, double _latitude, String ipaddress) async {
    checkLainnya(_longitude, _latitude, ipaddress);
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        sendResult(classid, number, _longitude, _latitude, ipaddress);
      },
    );

    Widget cancelButton = FlatButton(
      child: Text("Batal"),
      onPressed: () {
        Navigator.of(cont).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text('Anda Menghadiri Kuliah :'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text("NIM"),
                    flex: 3,
                  ),
                  Expanded(
                    child: Text(":"),
                    flex: 1,
                  ),
                  Expanded(
                    child: Text(number),
                    flex: 8,
                  ),
                ],
              )),
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text("Mata Kuliah"),
                    flex: 3,
                  ),
                  Expanded(
                    child: Text(":"),
                    flex: 1,
                  ),
                  Expanded(
                    child: Text(classid),
                    flex: 8,
                  ),
                ],
              )),
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text("Tanggal"),
                    flex: 3,
                  ),
                  Expanded(
                    child: Text(":"),
                    flex: 1,
                  ),
                  Expanded(
                    child: Text(DateTime.now().toString()),
                    flex: 8,
                  ),
                ],
              )),
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text("Ket"),
                    flex: 3,
                  ),
                  Expanded(
                    child: Text(":"),
                    flex: 1,
                  ),
                  Expanded(
                    child: Text(status),
                    flex: 8,
                  ),
                ],
              )),
        ],
      ),
      actions: <Widget>[cancelButton, okButton],
    );

    showDialog(
      context: cont,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  backAction(Widget previous, BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => previous,
        ));
  }

  void sendResult(String classid, String number, double longitude, double latitude, String ipaddress) async {
    final response = await http.post(
        "https://api.akprind.ac.id/presensimandiri/apiflutter/apiflutter.php?apicall=hadir",
        body: {"idkuliah": classid,"username": number, "longitude": longitude, "latitude": latitude, "ipaddress": ipaddress});
    if (response.statusCode == 200){
      final jsonData = jsonDecode(response.body);
      toast(jsonData["message"]);
    }else {
      toast("Gagal Terhubung Ke Server");
    }
  }
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newpresensimandiri/main.dart';
import 'package:newpresensimandiri/utils/utils.dart';
import 'package:newpresensimandiri/utils/utilsettings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isSwitched = true;
  String number, message;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _isSwitched = preferences.getBool('notif') == true ? true : false;
      number = preferences.getString('username');
    });
    getMessage(number);
  }


  getMessage(String username) async {
    final response = await http.get(
        'https://api.akprind.ac.id/presensimandiri/apiflutter/apijadwal.php?nim=$username');
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        message = jsonData['message'];
      });
    }
  }

  setPref(bool val) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (val) {
      Utils().toast('Notifikasi Dinyalakan');
      UtilSetting().showNotificationdaily(context, message);
    } else{
      Utils().toast('Notifikasi Dimatikan');
      UtilSetting().cancelNotification(context);
    }
    setState(() {
      _isSwitched = val;
      preferences.setBool("notif", val);
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: BackButton(
              onPressed: () {
                Utils().backAction(MyApp(), context);
              },
            ),
            title: Text("Pengaturan")),
        body: Row(
          children: <Widget>[
            Expanded(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                    child: Text('Notifikasi')),
                flex: 7),
            Switch(
              value: _isSwitched,
              onChanged: (val) => setPref(val),
            ),
          ],
        ));
  }
}

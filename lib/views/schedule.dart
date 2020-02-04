import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newpresensimandiri/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/modschedule.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  var loading = false;
  var list = new List<Schedule>();
  var number;

  Future<List<Schedule>> getSchedule(String username) async {
    final response = await http.get(
        'https://api.akprind.ac.id/presensimandiri/apiflutter/apijadwal.php?nim=$username');
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      bool status = jsonData['status'];
      if (!status) {
        String message = jsonData['message'];
        Utils().toast(message);
        loading = false;
      } else {
        list = jsonData['data']
            .map<Schedule>((j) => Schedule.fromJson(j))
            .toList();
        loading = false;
      }
    } else {
      Utils().toast('Gagal Tehubung Ke Server');
    }
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      number = preferences.getString("username");
      getSchedule(number);
    });
  }

  @override
  void initState() {
    super.initState();
    loading = true;
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, i) {
                final x = list[i];
                return Card(
                    child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                          height: 50,
                          width: 70,
                          child: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text(
                                x.time,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              x.subject + ' (' + x.room + ')',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            Text(x.lecture)
                          ],
                        ),
                      ),
                    ],
                  ),
                ));
              },
            ),
    );
  }
}

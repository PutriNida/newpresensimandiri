import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newpresensimandiri/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/modsubject.dart';

class SubjectsPage extends StatefulWidget {
  @override
  _SubjectsPageState createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  var loading = false;
  var list = new List<Subjects>();
  var number;

  Future<List<Subjects>> getSubjects(String username) async {
    final response = await http.get(
        'https://api.akprind.ac.id/presensimandiri/apiflutter/apikrs.php?nim=$username');
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      bool status = jsonData['status'];
      if (!status) {
        String message = jsonData['message'];
        Utils().toast(message);
      } else {
        list = jsonData['data']
            .map<Subjects>((j) => Subjects.fromJson(j))
            .toList();
        loading = false;
      }
    } else {
      Utils().toast('Gagal Tehubung Ke Server');
    }
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    number = preferences.getString("username");
    getSubjects(number);
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
                        height: 60,
                        width: 75,
                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                x.day,
                                style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                x.time,
                                style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              x.subject + ' (' + x.room + ')',
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
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

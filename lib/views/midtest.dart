import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newpresensimandiri/models/modtest.dart';
import 'package:newpresensimandiri/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MidTestPage extends StatefulWidget {
  @override
  _MidTestPageState createState() => _MidTestPageState();
}

class _MidTestPageState extends State<MidTestPage> {
  var loading = false;
  var list = new List<TestAll>();
  var number;

  Future<List<TestAll>> getTest(String username) async {
    final response = await http.get(
        'https://api.akprind.ac.id/presensimandiri/apiflutter/apiujian.php?nim=$username&status=uts');
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      bool error = jsonData['error'];
      if (error) {
        String message = jsonData['message'];
        Utils().toast(message);
        setState(() {
          loading = false;
        });
      } else {
        list = jsonData['data'].map<TestAll>((j) => TestAll.fromJson(j)).toList();
        setState(() {
          loading = false;
        });
      }
    } else {
      Utils().toast('Gagal Tehubung Ke Server');
      setState(() {
        loading = false;
      });
    }
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      number = preferences.getString("username");
    });
    getTest(number);
  }

  @override
  void initState() {
    super.initState();
    loading=true;
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        x.subject,
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      Text(x.day+", "+x.date+", "+x.time+", "+x.room)
                    ],
                  ),
                ));
              },
            ),
    );
  }
}

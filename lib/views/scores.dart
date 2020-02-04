import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newpresensimandiri/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/modscore.dart';

class ScoresPage extends StatefulWidget {
  @override
  _ScoresPageState createState() => _ScoresPageState();
}

class _ScoresPageState extends State<ScoresPage> {
  var loading = false;
  var list = new List<Scores>();
  var number, ipsem, jusks;
  AlertDialog alert;

  Future<List<Scores>> getScores(String username) async {
    final response = await http.get(
        'https://api.akprind.ac.id/presensimandiri/apiflutter/apitotal.php?nim=$username');
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      bool status = jsonData['status'];
      if (!status) {
        String message = jsonData['message'];
        Utils().toast(message);
      } else {
        ipsem = jsonData['ipsem'];
        jusks = jsonData['jumsks'];
        list = jsonData['data'].map<Scores>((j) => Scores.fromJson(j)).toList();
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
      getScores(number);
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
          : Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'IP Semester = $ipsem',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  Text('SKS Semester = $jusks',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, i) {
                        final x = list[i];
                        return GestureDetector(
                          onTap: () => showAlertDialog(
                              context,
                              x.subject,
                              x.task1,
                              x.task2,
                              x.task3,
                              x.task4,
                              x.midtest,
                              x.lasttest,
                              x.finalscore,
                              x.presence,
                              x.credit),
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      x.subject,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    flex: 11,
                                  ),
                                  Expanded(
                                    child: Icon(Icons.arrow_drop_down),
                                    flex: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

showAlertDialog(
    BuildContext context,
    String subject,
    String task1,
    String task2,
    String task3,
    String task4,
    String midtest,
    String lasttest,
    String finalscore,
    String presence,
    String credit) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(subject),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text('Tugas'),
                flex: 4,
              ),
              Expanded(
                child: Text(task1),
                flex: 2,
              ),
              Expanded(
                child: Text(task2),
                flex: 2,
              ),
              Expanded(
                child: Text(task3),
                flex: 2,
              ),
              Expanded(
                child: Text(task4),
                flex: 2,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text('UTS'),
                flex: 4,
              ),
              Expanded(
                child: Text(midtest),
                flex: 2,
              ),
              Expanded(
                child: Text('UAS'),
                flex: 4,
              ),
              Expanded(
                child: Text(lasttest),
                flex: 2,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text('SKS'),
                flex: 4,
              ),
              Expanded(
                child: Text(credit),
                flex: 2,
              ),
              Expanded(
                child: Text('Akhir'),
                flex: 4,
              ),
              Expanded(
                child: Text(finalscore),
                flex: 2,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text('Kehadiran'),
                flex: 5,
              ),
              Expanded(
                child: Text(presence),
                flex: 7,
              ),
            ],
          ),
        ),
      ],
    ),
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

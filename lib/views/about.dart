import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newpresensimandiri/main.dart';
import 'package:newpresensimandiri/utils/introslider.dart';
import 'package:newpresensimandiri/utils/utilabout.dart';
import 'package:newpresensimandiri/utils/utils.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Utils().backAction(MyApp(), context);
            },
          ),
          title: Text("Tentang")),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Text(
              "PREMAN ISTA",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text("Versi "),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Image.asset("assets/logo.png"),
            ),
            FlatButton(
              child: Text(
                "Petunjuk".toUpperCase(),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo),
              ),
              onPressed: () {Utils().backAction(IntroScreen(), context);},
            ),
            FlatButton(
              child: Text(
                "Hubungi Kami".toUpperCase(),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo),
              ),
              onPressed: () {
                UtilAbout().sendHelp();
              },
            ),
            Text("© 2020 BP3SI")
          ],
        ),
      ),
    );
  }
}

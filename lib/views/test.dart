import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newpresensimandiri/main.dart';
import 'package:newpresensimandiri/utils/utils.dart';
import 'package:newpresensimandiri/views/lasttest.dart';
import 'package:newpresensimandiri/views/midtest.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestPage extends StatefulWidget{
  @override
_TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with SingleTickerProviderStateMixin {
  TabController tabController;

  var mreg;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      mreg = preferences.getString("mreg");
    });
  }

  @override
  void initState() {
    getPref();
    super.initState();
    tabController = new TabController(length: 2, vsync: this);
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
          title: Text("Jadwal Ujian"),
      bottom: new TabBar(controller: tabController, tabs: <Widget>[
      new Tab(
        text: 'UTS ($mreg)',
      ),
      new Tab(
        text: 'UAS ($mreg)',
      )
    ]),
    ),
    body: new TabBarView(
    controller: tabController,
    children: <Widget>[MidTestPage(), LastTestPage()]),
    );
  }
}
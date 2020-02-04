import 'dart:async';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get_ip/get_ip.dart';
import 'package:location/location.dart';
import 'package:newpresensimandiri/models/modoption.dart';
import 'package:newpresensimandiri/utils/utils.dart';
import 'package:newpresensimandiri/utils/utilsettings.dart';
import 'package:newpresensimandiri/views/about.dart';
import 'package:newpresensimandiri/views/profile.dart';
import 'package:newpresensimandiri/views/schedule.dart';
import 'package:newpresensimandiri/views/scores.dart';
import 'package:newpresensimandiri/views/setting.dart';
import 'package:newpresensimandiri/views/subjects.dart';
import 'package:newpresensimandiri/views/test.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Presensi Mandiri',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();

  void signout() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('login', 'logOut');
  }
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  var login = '';
  var name = '';
  var number = '';
  var mreg = '';
  var newPage = '';

  TabController tabController;
  final GlobalKey<ScaffoldState> snackKey = GlobalKey<ScaffoldState>();
  String result;

  double _longitude;
  double _latitude;
  LocationData userLocation;
  StreamSubscription<LocationData> locationSubcription;
  Location location = new Location();
  String error;

  String ip_address;

  OptionMenu _selected = optionMenu[0];

  void getIpAddress() async {
    ip_address = await GetIp.ipAddress;
    if (ip_address == null) ip_address = await GetIp.ipv6Address;
  }

  void getLocation() async {
    LocationData mylocation;
    try {
      mylocation = await location.getLocation();
      error = "";
      _longitude = mylocation.longitude;
      _latitude = mylocation.latitude;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED')
        error = 'Permission Denied';
      else if (e.code == 'PERMISSION_DENIED_NEVER_ASK')
        error = 'Please enable the GPS';
      mylocation = null;
    }
  }

  void _select(OptionMenu choice) {
    _selected = choice;
    if (_selected.title == 'Profil')
      login = "profil";
    else if (_selected.title == 'Pengaturan')
      login = "setting";
    else if (_selected.title == 'Tentang')
      login = "about";
    else if (_selected.title == 'Jadwal Ujian')
      login = "test";
    else if (_selected.title == 'Logout') signOut();
  }

  checkLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      login = preferences.getString('login') == 'logIn' ? 'logIn' : 'logOut';
    });
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString("nama");
      number = preferences.getString("username");
      mreg = preferences.getString("mreg");
    });
  }

  Future scan(String number) async {
    getLocation();
    getIpAddress();
    try {
      String barcode = await scanner.scan();
      setState(() => this.result = barcode);
      Utils().sendPresence(
          number, result, context, _longitude, _latitude, ip_address);
    } on PlatformException catch (e) {
      if (e.code == scanner.CameraAccessDenied) {
        setState(() {
          this.result = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.result = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.result =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.result = 'Unknown error: $e');
    }
  }

  void signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('login', 'logOut');
    setState(() {
      login = 'logOut';
    });
    UtilSetting().cancelNotification(context);
//    Utils().toast(login);
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
    tabController = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    switch (login) {
      case 'logIn':
        getPref();

        return Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: EdgeInsets.all(8.0),
              child: Image.asset('assets/logo.png'),
            ),
            title: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(name ?? 'Nama', style: TextStyle(fontSize: 18)),
                  Text(number ?? 'NIM', style: TextStyle(fontSize: 15))
                ],
              ),
            ),
            actions: <Widget>[
              PopupMenuButton<OptionMenu>(
                elevation: 3.2,
                onSelected: _select,
                itemBuilder: (BuildContext context) {
                  return optionMenu.map((OptionMenu choice) {
                    return PopupMenuItem<OptionMenu>(
                      value: choice,
                      child: Text(choice.title),
                    );
                  }).toList();
                },
              )
            ],
            bottom: new TabBar(controller: tabController, tabs: <Widget>[
              new Tab(
                text: 'Jadwal ($mreg)',
              ),
              new Tab(
                text: 'KRS ($mreg)',
              ),
              new Tab(
                text: 'Nilai ($mreg)',
              )
            ]),
          ),
          key: snackKey,
          body: DoubleBackToCloseApp(
            child: TabBarView(
                controller: tabController,
                children: <Widget>[SchedulePage(), SubjectsPage(), ScoresPage()]),
            snackBar: SnackBar(content: Text('Tekan Back sekali lagi')),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              scan(number);
            },
            child: Icon(Icons.center_focus_weak),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        );
        break;
      case 'logOut':
        return LoginPage();
        break;

      case 'profil':
        return ProfilePage();
        break;

      case 'setting':
        return SettingsPage();
        break;

      case 'test':
        return TestPage();
        break;

      case 'about':
        return AboutPage();
        break;
    }
    return Scaffold();
  }
}

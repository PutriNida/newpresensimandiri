import 'dart:convert';
import 'dart:io';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newpresensimandiri/utils/utillogin.dart';
import 'package:newpresensimandiri/utils/utils.dart';
import 'package:newpresensimandiri/utils/utilsettings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';
import 'models/modlogin.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>(); //MEMBUAT GLOBAL KEY UNTUK VALIDASI
  var login = 'logOut';

  // DEFINE VARIABLE
  String username = '';
  String pswd = '';
  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  Future aksilogin() async {
    final response = await http.post(
        "https://api.akprind.ac.id/presensimandiri/apiflutter/apilogin.php",
        body: {"nim": username, "password": pswd});
    final jsonData = jsonDecode(response.body);
    Result data = Result.fromJson(jsonData);
    bool error = data.error;
    String message = data.message;

    if (!error) {
      String uname = data.mahasiswa.username;
      String nama = data.mahasiswa.nama;
      String mreg = data.mahasiswa.mreg;
      setState(() {
        login = 'logIn';
        savePref(login, uname, nama, mreg);
      });
      Utils().toast(message);
      getMessage(uname);
      Utils().backAction(MyHomePage(), context);
      UtilLogin().checkData(context, uname);
    } else {
      Utils().toast(message);
    }
  }

  getMessage(String username) async {
    final response = await http.get(
        'https://api.akprind.ac.id/presensimandiri/apiflutter/apijadwal.php?nim=$username');
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      UtilSetting().showNotification(context, jsonData['message']);
      UtilSetting().showNotificationdaily(context, jsonData['message']);
    }
  }

  savePref(String login, String uname, String nama, String mreg) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("login", login);
      preferences.setString("username", uname);
      preferences.setString("nama", nama);
      preferences.setString("mreg", mreg);
      preferences.setBool("notif", true);
    });
//    Utilstoast().toast(preferences.getString("login"));
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      login = preferences.getString('login') == 'logIn' ? 'logIn' : 'logOut';
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (login) {
      case 'logIn':
        return MyHomePage();
        break;
      case 'logOut':
        return Scaffold(
            backgroundColor: Colors.lightBlueAccent,
            body: DoubleBackToCloseApp(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 40.0),
                      child: Image.asset("assets/ist.png"),
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 30.0),
                        color: Colors.white70,
                        child: Form(
                            key: formKey,
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    hintText: "NIM",
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 2.0),
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  maxLength: 9,
                                  // ignore: missing_return
                                  validator: (e) {
                                    if (e.isEmpty) {
                                      return "Silahkan Masukkan NIM";
                                    } else if (e.length < 9) {
                                      return "NIM terdiri dari 9 digit";
                                    }
                                  },
                                  onSaved: (String uname) {
                                    username = uname;
                                  },
                                ),
                                TextFormField(
                                    decoration: InputDecoration(
                                      hintText: "Password",
                                      suffixIcon: IconButton(
                                        onPressed: showHide,
                                        icon: Icon(_secureText
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 2.0),
                                        borderRadius: BorderRadius.circular(25.0),
                                      ),
                                    ),
                                    obscureText: _secureText,
                                    maxLength: 9,
                                    // ignore: missing_return
                                    validator: (e) {
                                      if (e.isEmpty) {
                                        return "Silahkan Masukkan NIM";
                                      }
                                    },
                                    onSaved: (String psw) {
                                      pswd = psw;
                                    }),
                                FlatButton(
                                  onPressed: () {
                                    UtilLogin().forgetPassword(context);
                                  },
                                  child: Text("Lupa Password ? Klik Disini",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.indigo)),
                                ),
                                RaisedButton(
                                  onPressed: () {
                                    if (formKey.currentState.validate()) {
                                      formKey.currentState.save();
                                      aksilogin();
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(20.0),
                                    side: BorderSide(
                                      color: Colors.indigo,
                                    ),
                                  ),
                                  child: Text("LOGIN",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                  color: Colors.indigo,
                                ),
                              ],
                            ))),
                  ],
                ),
              ),
              snackBar: SnackBar(content: Text('Tekan Back sekali lagi')),
            ),
          );
        break;
    }
    return Scaffold();
  }
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newpresensimandiri/main.dart';
import 'package:newpresensimandiri/models/modoption.dart';
import 'package:newpresensimandiri/utils/profilesetting.dart';
import 'package:newpresensimandiri/utils/utillogin.dart';
import 'package:newpresensimandiri/utils/utils.dart';
import 'package:newpresensimandiri/views/completedata.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var page;
  var loading = false;
  String imagepath;
  var number;
  String name, level, studyprogram, majors, faculty, year;
  String birthday,
      birthplace,
      gender,
      nik,
      religion,
      citizenship,
      address,
      district,
      province,
      postal_code,
      mother,
      email;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      number = preferences.getString("username");
      name = preferences.getString("nama");
      getPhoto(number);
    });
  }

  Future getPhoto(String number) async {
    final response = await http.post(
        'https://api.akprind.ac.id/presensimandiri/apiflutter/apiflutter.php?apicall=cekfoto',
        body: {"username": number});
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        imagepath = jsonData['data'];
        page = "profil";
        loading = false;
        getProfile();
      });
    } else {
      Utils().toast('Gagal Tehubung Ke Server');
    }
  }

  Future getProfile() async {
    final response = await http.get(
        "https://api.akprind.ac.id/presensimandiri/apiflutter/apiprofil.php?nim=$number");
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData["status"]) {
        setState(() {
          level = jsonData["jjg"];
          studyprogram = jsonData["prodi"];
          majors = jsonData["jur"];
          faculty = jsonData["fak"];
          year = jsonData["ang"];
          birthday = jsonData["tgllahir"];
          birthplace = jsonData["tmptlahir"];
          gender = jsonData["jk"];
          nik = jsonData["nik"];
          religion = jsonData["agm"];
          citizenship = jsonData["wn"];
          address = jsonData["alamat"];
          district = jsonData["kab"];
          province = jsonData["prop"];
          postal_code = jsonData["kodepos"];
          mother = jsonData["ortu"];
          email = jsonData["email"];
        });
      } else {
        Utils().toast(jsonData["message"]);
      }
    } else {
      Utils().toast('Gagal Tehubung Ke Server');
    }
  }

  void _select(OptionProfile value) {
    if (value.no == 1)
      ProfileSetting().changePassword(context, number);
    else if (value.no == 2)
      ProfileSetting().changePhoto(context, number);
    else if (value.no == 3) {
      Utils().backAction(CompletingPage(), context);
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();
    setState(() {
      loading = true;
    });
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
          title: Text("Profil Mahasiswa"),
          actions: <Widget>[
            PopupMenuButton<OptionProfile>(
              elevation: 3.2,
              onSelected: _select,
              itemBuilder: (BuildContext context) {
                return optionProfile.map((OptionProfile choice) {
                  return PopupMenuItem<OptionProfile>(
                    value: choice,
                    child: Text(choice.title),
                  );
                }).toList();
              },
            )
          ],
        ),
        body: loading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                            width: 190.0,
                            height: 190.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(imagepath)))),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) {
                          return DetailScreen(imagepath);
                        })),
                      ),
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text("Nama"),
                                flex: 4,
                              ),
                              Expanded(
                                child: Text(
                                  name.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                flex: 8,
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text("NIM"),
                                flex: 4,
                              ),
                              Expanded(
                                child: Text(number.toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                flex: 8,
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text("Jenjang"),
                                flex: 4,
                              ),
                              Expanded(
                                child: Text('$level'.toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                flex: 8,
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text("Prodi"),
                                flex: 4,
                              ),
                              Expanded(
                                child: Text('$studyprogram'.toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                flex: 8,
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text("Jurusan"),
                                flex: 4,
                              ),
                              Expanded(
                                child: Text('$majors'.toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                flex: 8,
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text("Fakultas"),
                                flex: 4,
                              ),
                              Expanded(
                                child: Text('$faculty'.toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                flex: 8,
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text("Angkatan"),
                                flex: 4,
                              ),
                              Expanded(
                                child: Text('$year'.toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                flex: 8,
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text("Tanggal Lahir"),
                                flex: 4,
                              ),
                              Expanded(
                                child: Text(
                                  "$birthday".toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                flex: 8,
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text("Tempat Lahir"),
                                flex: 4,
                              ),
                              Expanded(
                                child: Text(
                                  "$birthplace".toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                flex: 8,
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text("Jenis Kelamin"),
                                flex: 4,
                              ),
                              Expanded(
                                child: Text(
                                  "$gender".toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                flex: 8,
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text("Agama"),
                                flex: 4,
                              ),
                              Expanded(
                                child: Text(
                                  "$religion".toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                flex: 8,
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text("NIK"),
                                flex: 4,
                              ),
                              Expanded(
                                child: Text(
                                  "$nik".toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                flex: 8,
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text("Kewarganegaraan"),
                                flex: 4,
                              ),
                              Expanded(
                                child: Text(
                                  "$citizenship".toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                flex: 8,
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text("E-Mail"),
                                flex: 4,
                              ),
                              Expanded(
                                child: Text(
                                  "$email".toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                flex: 8,
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text("Alamat"),
                                flex: 4,
                              ),
                              Expanded(
                                child: Text(
                                  "$address".toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                flex: 8,
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text("Kode Pos"),
                                flex: 4,
                              ),
                              Expanded(
                                child: Text(
                                  "$postal_code".toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                flex: 8,
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text("Nama Ibu"),
                                flex: 4,
                              ),
                              Expanded(
                                child: Text(
                                  "$mother".toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                flex: 8,
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ));
  }
}

class DetailScreen extends StatelessWidget {
  String imagePath;

  DetailScreen(String imagepath) {
    imagePath = imagepath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'FotoProfil',
            child: Image.network(imagePath),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newpresensimandiri/login.dart';
import 'package:newpresensimandiri/main.dart';
import 'package:newpresensimandiri/utils/utillogin.dart';
import 'package:newpresensimandiri/utils/utils.dart';
import 'package:newpresensimandiri/views/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CompletingPage extends StatefulWidget {
  @override
  _CompletingPageState createState() => _CompletingPageState();
}

class _CompletingPageState extends State<CompletingPage> {
  final formKey = GlobalKey<FormState>(); //MEMBUAT GLOBAL KEY UNTUK VALIDASI
  final format = DateFormat('yyyy-MM-dd');
  var birthday;
  bool completed;

  String number,
      gender,
      religion,
      citizenship,
      _birthday,
      _birthplace,
      _nik,
      _address,
      _district,
      _province,
      _postal_code,
      _mother,
      _email;

  static final TextEditingController _Birthday = TextEditingController();
  static final TextEditingController birthplace = TextEditingController();
  static final TextEditingController nik = TextEditingController();
  static final TextEditingController address = TextEditingController();
  static final TextEditingController district = TextEditingController();
  static final TextEditingController province = TextEditingController();
  static final TextEditingController postal_code = TextEditingController();
  static final TextEditingController mother = TextEditingController();
  static final TextEditingController email = TextEditingController();

  Future getProfile() async {
    final response = await http.get(
        "https://api.akprind.ac.id/presensimandiri/apiflutter/apiprofil.php?nim=$number");
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData["status"]) {
        setState(() {
          gender = jsonData["jk"];
          religion = jsonData["agm"];
          birthday = DateTime.parse(jsonData["tgllahir"]);
          citizenship = jsonData["wn"];
          completed = jsonData["lengkap"];

          _Birthday.text = jsonData["tgllahir"];
          birthplace.text = jsonData["tmptlahir"];
          nik.text = jsonData["nik"];
          address.text = jsonData["alamat"];
          district.text = jsonData["kab"];
          province.text = jsonData["prop"];
          postal_code.text = jsonData["kodepos"];
          mother.text = jsonData["ortu"];
          email.text = jsonData["email"];
        });
      } else {
        Utils().toast(jsonData["message"]);
      }
    } else {
      Utils().toast('Gagal Tehubung Ke Server');
    }
  }

  void cancelButton() {
    if (completed){
      Utils().backAction(ProfilePage(), context);
    }else{
      MyHomePage().signout();
      Utils().backAction(LoginPage(), context);
    }
  }

  void getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      number = preferences.getString("username");
    });
    getProfile();
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 30.0),
                child: Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Lengkapi Data Mahasiswa',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        DateTimeField(
                          format: format,
                          decoration:
                          InputDecoration(labelText: "Tanggal Lahir"),
                          onShowPicker: (context, currentValue) {
                            return showDatePicker(
                                context: context,
                                firstDate: DateTime(1900),
                                initialDate: birthday ?? DateTime.now(),
                                lastDate: DateTime(2100));
                          },
                          controller: _Birthday,
                          onChanged: (value) {
                            setState(() {
                              _birthday = format.format(value);
                            });
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Tempat Lahir",
                          ),
                          controller: birthplace,
                          onSaved: (val) {
                            setState(() {
                              _birthplace = val;
                            });
                          },
                        ),
                        Text(''),
                        Text('Jenis Kelamin'),
                        Row(
                          children: <Widget>[
                            Radio(
                              value: 'Laki-Laki',
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value;
//                                  Utils().toast(gender);
                                });
                              },
                            ),
                            Text('Laki-Laki'),
                            Radio(
                              value: 'Perempuan',
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value;
//                                  Utils().toast(gender);
                                });
                              },
                            ),
                            Text('Perempuan'),
                          ],
                        ),
                        Text(''),
                        Text('Agama'),
                        Row(
                          children: <Widget>[
                            Radio(
                              value: 'Islam',
                              groupValue: religion,
                              onChanged: (value) {
                                setState(() {
                                  religion = value;
//                                  Utils().toast(religion);
                                });
                              },
                            ),
                            Text('Islam'),
                            Radio(
                              value: 'Kristen',
                              groupValue: religion,
                              onChanged: (value) {
                                setState(() {
                                  religion = value;
//                                  Utils().toast(religion);
                                });
                              },
                            ),
                            Text('Kristen'),
                            Radio(
                              value: 'Katholik',
                              groupValue: religion,
                              onChanged: (value) {
                                setState(() {
                                  religion = value;
//                                  Utils().toast(religion);
                                });
                              },
                            ),
                            Text('Katholik'),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Radio(
                              value: 'Hindhu',
                              groupValue: religion,
                              onChanged: (value) {
                                setState(() {
                                  religion = value;
//                                  Utils().toast(religion);
                                });
                              },
                            ),
                            Text('Budha'),
                            Radio(
                              value: 'Budha',
                              groupValue: religion,
                              onChanged: (value) {
                                setState(() {
                                  religion = value;
//                                  Utils().toast(religion);
                                });
                              },
                            ),
                            Text('Konghuchu'),
                            Radio(
                              value: 'Konghuchu',
                              groupValue: religion,
                              onChanged: (value) {
                                setState(() {
                                  religion = value;
//                                  Utils().toast(religion);
                                });
                              },
                            ),
                            Text('Hindhu'),
                          ],
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "NIK",
                          ),
                          controller: nik,
                          onSaved: (val) {
                            setState(() {
                              _nik = val;
                            });
                          },
                        ),
                        Text(''),
                        Text('Kewarganegaraan'),
                        Row(
                          children: <Widget>[
                            Radio(
                              value: 'WNI',
                              groupValue: citizenship,
                              onChanged: (value) {
                                setState(() {
                                  citizenship = value;
//                                  Utils().toast(citizenship);
                                });
                              },
                            ),
                            Text('WNI'),
                            Radio(
                              value: 'WNA',
                              groupValue: citizenship,
                              onChanged: (value) {
                                setState(() {
                                  citizenship = value;
//                                  Utils().toast(citizenship);
                                });
                              },
                            ),
                            Text('WNA')
                          ],
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "E-Mail",
                          ),
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (val) {
                            setState(() {
                              _email = val;
                            });
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Alamat",
                          ),
                          controller: address,
                          onSaved: (val) {
                            setState(() {
                              _address = val;
                            });
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Kode Pos",
                          ),
                          keyboardType: TextInputType.number,
                          controller: postal_code,
                          onSaved: (val) {
                            setState(() {
                              _postal_code = val;
                            });
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Nama Ibu",
                          ),
                          controller: mother,
                          onSaved: (val) {
                            setState(() {
                              _mother = val;
                            });
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Expanded(
                                  child: RaisedButton(
                                      onPressed: () {
                                        cancelButton();
                                      },
                                      child: Text("Batal")),
                                  flex: 3,
                                ),
                                Expanded(child: Text(""), flex: 2,),
                                Expanded(
                                  child: RaisedButton(
                                      onPressed: () {
                                        UtilLogin().completingData(
                                            context,
                                            number,
                                            _birthday,
                                            _birthplace,
                                            gender,
                                            _nik,
                                            religion,
                                            citizenship,
                                            _address,
                                            _postal_code,
                                            _mother,
                                            _email);
                                      }, child: Text("Simpan")),
                                  flex: 3,
                                )
                              ]),
                        )
                      ],
                    ))),
          ],
        ),
      ),
    );
  }
}

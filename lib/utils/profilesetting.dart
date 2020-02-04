import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ProfileSetting {
  String newpassword;
  File file;

  void changePassword(BuildContext cont, String number) {
    Widget okButton = FlatButton(
      child: Text("Simpan"),
      onPressed: () {
        savePassword(number);
      },
    );

    Widget cancelButton = FlatButton(
      child: Text("Batal"),
      onPressed: () {
        Navigator.of(cont).pop();
      },
    );
    AlertDialog input = AlertDialog(
      title: Text("Masukkan Password Baru"),
      content: Row(
        children: <Widget>[
          Expanded(
              child: new TextField(
            autofocus: true,
            decoration: new InputDecoration(labelText: 'Password Baru'),
            obscureText: true,
            onChanged: (value) {
              newpassword = value;
            },
          ))
        ],
      ),
      actions: <Widget>[cancelButton, okButton],
    );
    showDialog(
      context: cont,
      builder: (BuildContext context) {
        return input;
      },
    );
  }

  void changePhoto(BuildContext cont, String number) async {
    SimpleDialog simpleDialog = SimpleDialog(title: const Text('Ubah Foto Profil '), children: <Widget>[
      SimpleDialogOption(
        onPressed: () async {
          file = await ImagePicker.pickImage(source: ImageSource.camera);
        },
        child: const Text('Ambil Foto'),
      ),
      SimpleDialogOption(
        onPressed: () async {
          file = await ImagePicker.pickImage(source: ImageSource.gallery);
        },
        child: const Text('Pilih Foto'),
      ),
    ]);
    showDialog(
      context: cont,
      builder: (BuildContext context) {
        return simpleDialog;
      },
    );
    savePhoto(number);
  }

  void savePassword(String numbers) async {}

  void savePhoto(String numbers) async {
    if (file == null)
      return null;
    else {
      String base64Image = base64Encode(file.readAsBytesSync());
      http.post(
          "https://api.akprind.ac.id/presensimandiri/apiflutter/apiflutter.php?apicall=simpanfoto",
          body: {"username": numbers, "foto": base64Image}).then((res) {
        print(res.statusCode);
      }).catchError((err) {
        print(err);
      });
    }
  }

  void changeProfile(BuildContext context, number) {}
}

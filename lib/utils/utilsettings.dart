import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:newpresensimandiri/main.dart';
import 'package:newpresensimandiri/utils/utils.dart';
import 'package:http/http.dart' as http;

class UtilSetting {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future getVariable(BuildContext context) {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings("logo");
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: Utils().backAction(MyHomePage(), context));
  }

  void showNotificationdaily(BuildContext context, String message) async {
//    Utils().toast("Notifikasi dinyalakan");
    getVariable(context);

    var time = new Time(07, 0, 0);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        1, "Jadwal Hari Ini", message, time, platformChannelSpecifics);
  }

  void showNotification(BuildContext context, String message) async {
//    Utils().toast("Notifikasi dinyalakan showNotification awal");
    getVariable(context);

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        playSound: false, importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      "Jadwal Hari Ini",
      message,
      platformChannelSpecifics,
      payload: '',
    );
  }

  void cancelNotification(BuildContext context) async {
//    Utils().toast("Notifikasi dimatikan");
    getVariable(context);
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

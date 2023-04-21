import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:ui/services/local_notifications.dart';

class NotificationsPage extends StatefulWidget {
  NotificationsPage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String text = "";

  // @override
  // void initState() {
  //   super.initState();
  //   LocalNotificationService.initilize();

  //   FirebaseMessaging.instance.getInitialMessage().then((event) {
  //     print('terminated');
  //     setState(() {
  //       text =
  //           "${event?.notification?.title} + ${event?.notification?.body}, coming from terminated state";
  //     });
  //   });

  //   FirebaseMessaging.onMessageOpenedApp.listen((event) {
  //     print('background');
  //     setState(() {
  //       text =
  //           "${event?.notification?.title} + ${event?.notification?.body}, coming from background state";
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return Scaffold(
      appBar: AppBar(
        title: Text(translate('app_bar.settings_title')),
      ),
      body: Center(child: Text(text)),
    );
  }
}

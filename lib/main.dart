import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:ui/login.dart';
import 'package:ui/menu.dart';
import 'package:ui/services/api_service.dart';
import 'package:ui/services/local_notifications.dart';
import 'package:ui/settings.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message?.notification?.title);
  print(message?.notification?.body);
  print("coming from background ");
}

void main() async {
  var delegate = await LocalizationDelegate.create(
      fallbackLocale: 'en', supportedLocales: ['en', 'lt']);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LocalNotificationService.initilize();
  getRegistrationId();
  FirebaseMessaging.onMessage.listen((message) {
    print('hello from backend');
    inspect(message);
    LocalNotificationService.showNotificationOnForeground(message);
  });
  runApp(LocalizedApp(delegate, MyApp()));
}

void getRegistrationId() async {
  String? token = await FirebaseMessaging.instance.getToken();
  print("Registration ID: $token");
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          localizationDelegate
        ],
        supportedLocales: localizationDelegate.supportedLocales,
        locale: localizationDelegate.currentLocale,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomePage(),
      ),
    );
  }
}

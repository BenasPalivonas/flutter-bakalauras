import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ui/services/api_service.dart';

import '../assignments.dart';
import '../main.dart';
import '../menu.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initilize(BuildContext? context) {
    final InitializationSettings initializationSettings =
        const InitializationSettings(
            android:
                const AndroidInitializationSettings("@mipmap/ic_launcher"));
    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (context != null) {
        Assignment? assignment = null;
        if (USER_GROUP.isNotEmpty) {
          try {
            assignment = (await ApiService().getAssignment(payload!))!;
            Navigator.push(
                (context),
                MaterialPageRoute(
                    builder: (context) => const HomePage(
                          selectedIndex: 1,
                        )));
            showDetails(context, assignment!);
          } catch (e) {
            print(e);
          }
        }
      }
    });
  }

  static void showNotificationOnForeground(RemoteMessage message) {
    final notificationDetail = NotificationDetails(
      android: AndroidNotificationDetails(
        "com.example.firebase_push_notification",
        "firebase_push_notification",
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher', // Set the small icon for the notification
        largeIcon: const DrawableResourceAndroidBitmap(
            '@mipmap/ic_launcher'), // Set the large icon for the notification
        styleInformation: BigPictureStyleInformation(
          const DrawableResourceAndroidBitmap(
              '@mipmap/ic_launcher'), // The image to display
          contentTitle: message.notification!.title,
          summaryText: message.notification!.body,
        ),
      ),
    );

    _notificationsPlugin.show(
        DateTime.now().microsecond,
        message.notification!.title,
        message.notification!.body,
        notificationDetail,
        payload: message.data["id"]);
  }
}

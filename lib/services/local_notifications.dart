import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initilize() {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) {
      print(payload);
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
        largeIcon: DrawableResourceAndroidBitmap(
            '@mipmap/ic_launcher'), // Set the large icon for the notification
        styleInformation: BigPictureStyleInformation(
          DrawableResourceAndroidBitmap(
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
        payload: message.data["message"]);
  }
}

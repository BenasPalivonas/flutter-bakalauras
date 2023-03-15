import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    final androidInitializationSettings =
        AndroidInitializationSettings('mipmap/ic_launcher');
    final initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Send Notification in 1 minute'),
          onPressed: () async {
            await flutterLocalNotificationsPlugin.zonedSchedule(
                0,
                'Notification Title',
                'Notification Body',
                tz.TZDateTime.now(tz.local).add(Duration(minutes: 1)),
                NotificationDetails(
                  android: AndroidNotificationDetails(
                    'channel_id',
                    'Channel Name',
                  ),
                ),
                androidAllowWhileIdle: true,
                uiLocalNotificationDateInterpretation:
                    UILocalNotificationDateInterpretation.absoluteTime);
          },
        ),
      ),
    );
  }
}

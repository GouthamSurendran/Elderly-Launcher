import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationPlugin =
      FlutterLocalNotificationsPlugin();

  Future initialize() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation("Asia/Kolkata"));
    FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin =
        FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("ic_launcher");
    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: androidInitializationSettings,
            iOS: iosInitializationSettings);

    await flutterLocalNotificationPlugin.initialize(initializationSettings,
        );
  }

  Future scheduledNotification(DateTime now) async {
    var android = AndroidNotificationDetails("id", "channel", "description");
    final location = tz.getLocation("Asia/Kolkata");
    final date = tz.TZDateTime.from(now, location);

    await _flutterLocalNotificationPlugin.zonedSchedule(
        0,
        "Reminder for Medicine",
        "Tap for more info",
        _nextInstanceOfReminder(date),
        const NotificationDetails(
            android: AndroidNotificationDetails('daily notification channel id',
                'daily notification channel name', 'daily notification description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time
    );
  }

  tz.TZDateTime _nextInstanceOfReminder(tz.TZDateTime dateTime) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, dateTime.hour,dateTime.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future cancelNotification() async {
    await _flutterLocalNotificationPlugin.cancelAll();
  }
}

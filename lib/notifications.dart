import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService extends ChangeNotifier{
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();

  Future initialize () async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings("ic_launcher");
    IOSInitializationSettings iosInitializationSettings = IOSInitializationSettings();

    final InitializationSettings initializationSettings = InitializationSettings(
      android:  androidInitializationSettings,
      iOS: iosInitializationSettings
    );

    await flutterLocalNotificationPlugin.initialize(initializationSettings,onSelectNotification: (value){
      print("");
    });
  }

  Future scheduledNotification() async {
    var interval = RepeatInterval.everyMinute;
    var bigPicture = BigPictureStyleInformation(
      DrawableResourceAndroidBitmap("ic_launcher"),
      largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
      contentTitle: "Demo Image Notification",
      summaryText: "This sums up the notification",
      htmlFormatContent: true,
      htmlFormatContentTitle: true
    );
    var android = AndroidNotificationDetails("id", "channel", "description");
    var platform = new NotificationDetails(android: android);

    await _flutterLocalNotificationPlugin.periodicallyShow(0, "Reminder for Medicine", "Tap to do something",interval , platform);
  }

  Future cancelNotification() async {
    await _flutterLocalNotificationPlugin.cancelAll();
  }
}
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationHelper {
  static final _notification = FlutterLocalNotificationsPlugin();

  static init() async {
    await _notification.initialize(const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ));
    tz.initializeTimeZones();
  }

  static schedulNotification(
      String title, String description, int todotime, int id) async {
    var androidDetails = const AndroidNotificationDetails(
        "important_notification", "My Channel",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        fullScreenIntent: true);
    var notificationDetails = NotificationDetails(android: androidDetails);

    await _notification.zonedSchedule(
        id,
        title,
        description,
        tz.TZDateTime.now(tz.local).add(Duration(minutes: todotime)),
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
  }

  static cancelNotification(int todoId) {
    _notification.cancel(todoId);
  }
}

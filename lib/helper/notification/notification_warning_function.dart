import 'package:finance_tracker/helper/notification/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> showExpenseWarningNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'expense_channel', // channel id
        'Expense Alerts', // channel name
        channelDescription: 'Notifications when expenses exceed income',
        importance: Importance.high,
        priority: Priority.high,
      );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID
    'Warning!',
    'Your expenses have exceeded your income!',
    platformChannelSpecifics,
  );
}

import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> showTaskReminderNotification(
  int? hour,
  int? minute,
  int? day,
  int? month,
  int? year,
) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'scheduled_channel',
      title: '${Emojis.wheater_droplet} Add some water to your plant!',
      body: 'Water your plant regularly to keep it healthy.',
      notificationLayout: NotificationLayout.Default,
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'MARK_DONE',
        label: 'Mark Done',
      ),
    ],
    schedule: NotificationCalendar(
      year: year,
      month: month,
      day: day,
      hour: hour,
      minute: minute,
      second: 0,
      millisecond: 0,
    ),
  );
}

Future<void> showWeeklyTaskReminderNotification(
  int? hour,
  int? minute,
  int? weekDay,
) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'scheduled_channel',
      title: '${Emojis.wheater_droplet} Add some water to your plant!',
      body: 'Water your plant regularly to keep it healthy.',
      notificationLayout: NotificationLayout.Default,
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'MARK_DONE',
        label: 'Mark Done',
      ),
    ],
    schedule: NotificationCalendar(
      weekday: weekDay,
      hour: hour,
      minute: minute,
      second: 0,
      millisecond: 0,
    ),
  );
}

Future<void> cancelScheduledNotifications() async {
  await AwesomeNotifications().cancelAllSchedules();
}

int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}

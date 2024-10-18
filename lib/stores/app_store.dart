import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobx/mobx.dart';
import 'package:weight_tracker/models/preferences.dart';
import 'package:weight_tracker/repositories/db.dart';
import 'package:weight_tracker/repositories/di.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class AppStore {
  AppDelegate? delegate;
  DatabaseService get db => getIt<DatabaseService>();

  Future<void> init() async {
    tz.initializeTimeZones();
    //tz.setLocalLocation(tz.getLocation(timeZoneName));

    final pref = await db.preferences();

    if (pref == null) setPreferencesPage();

    _updatePrefs(pref);

    db.preferenceStream?.listen((_) async {
      final pref = await db.preferences();
      _updatePrefs(pref);
    });
  }

  void _updatePrefs(Preferences? pref) {
    runInAction(() {
      _name.value = pref?.name ?? '';
      _goal.value = (pref?.goal ?? '').toString();
    });
  }

  void setPreferencesPage() => delegate?.navigateToPreferences();

  final Observable<String> _name = Observable('');
  final Observable<String> _goal = Observable('');

  late final Computed<String> name = Computed(() => _name.value);
  late final Computed<String> goal = Computed(() => _goal.value);

  void setNotifications() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancelAll();
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Record your weight today!',
      'Make sure you stick to the schedule & record your weight today.',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'weight_recorder_srj',
          'weight_recorder_srj',
          channelDescription: '',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}

abstract class AppDelegate {
  void navigateToPreferences();
}

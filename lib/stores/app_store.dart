import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:weight_tracker/models/preferences.dart';
import 'package:weight_tracker/models/weight.dart';
import 'package:weight_tracker/repositories/db.dart';
import 'package:weight_tracker/repositories/di.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:weight_tracker/repositories/extensions.dart';

class AppStore {
  AppDelegate? delegate;
  DatabaseService get db => getIt<DatabaseService>();
  FlutterLocalNotificationsPlugin get notifications =>
      getIt<FlutterLocalNotificationsPlugin>();

  Future<void> init() async {
    tz.initializeTimeZones();

    final pref = await db.preferences();

    if (pref?.name == null || pref?.goal == null) setPreferencesPage();

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    notifications.initialize(initializationSettings);

    notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
    _updatePrefs(pref);

    db.preferenceStream?.listen((_) async {
      final pref = await db.preferences();
      _updatePrefs(pref);
    });

    db.weightsStream?.listen((_) async {
      final weights = await db.weights();

      runInAction(() {
        _weights.clear();
        _weights.addAll(weights);
      });
    });

    final today = await db.weightOnDay(DateTime.now().woTime());
    final weightsExist = await db.areWeightsInitialized();

    if (weightsExist && today == null) {
      await db.addOrUpdateWeight(-1, DateTime.now().woTime());
    }
  }

  void _updatePrefs(Preferences? pref) {
    runInAction(() {
      _name.value = pref?.name ?? '';
      _goal.value = pref?.goal ?? -1;
      _time.value = (DateFormat.jm().format(pref?.time ?? DateTime(0)));
    });
  }

  void setPreferencesPage() => delegate?.navigateToPreferences();

  final Observable<String> _name = Observable('');
  final Observable<double> _goal = Observable(-1);
  final Observable<String> _time = Observable('');

  late final Computed<String> name = Computed(() => _name.value);
  late final Computed<double> goal = Computed(() => _goal.value);
  late final Computed<String> time = Computed(() => _time.value);

  final ObservableList<Weight> _weights = ObservableList.of([]);
  late final Computed<List<Weight>> weights = Computed(() => _weights);

  void setNotifications(TimeOfDay time) async {
    DateTime now = DateTime.now();

    DateTime dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancelAll();
    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      'Record your weight today!',
      'Make sure you stick to the schedule & record your weight today.',
      tz.TZDateTime.from(dateTime, tz.local),
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

    await db.setTime(dateTime);
  }
}

abstract class AppDelegate {
  void navigateToPreferences();
}

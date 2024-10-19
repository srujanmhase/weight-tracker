import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:weight_tracker/repositories/db.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<DatabaseService>(DatabaseService());
  getIt.registerSingleton<FlutterLocalNotificationsPlugin>(
    FlutterLocalNotificationsPlugin(),
  );
}

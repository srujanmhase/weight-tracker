import 'package:get_it/get_it.dart';
import 'package:weight_tracker/repositories/db.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<DatabaseService>(DatabaseService());
}

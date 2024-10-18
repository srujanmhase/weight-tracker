import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weight_tracker/models/preferences.dart';
import 'package:weight_tracker/models/weight.dart';

class DatabaseService {
  DatabaseService() {
    _init();
  }

  Isar? isar;

  Future<void> _init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [WeightSchema, PreferencesSchema],
      directory: dir.path,
    );
  }

  Future<Preferences?> preferences() async {
    if (isar == null) await _init();

    final prefs = await isar?.preferences.get(1);

    return prefs;
  }

  late final Stream<void>? preferenceStream = isar?.preferences.watchLazy();

  // userChanged.listen(() {
  //   print('A User changed');
  // });

  late final Stream<void>? weightsStream = isar?.weights.watchLazy();

  Future<void> addOrUpdateWeight(double weight, DateTime day) async {
    if (isar == null) await _init();

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(day);

    final existingWeight = await isar?.weights
            .filter()
            .dayEqualTo(formatted)
            .findFirst() ??
        Weight()
      ..day = formatted;

    existingWeight.weight = weight;
    await isar?.writeTxn(() async {
      isar?.weights.put(existingWeight);
    });
  }

  Future<void> setName(String newName) async {
    if (isar == null) await _init();

    final prefs = await preferences() ?? Preferences();

    final preference = prefs..name = newName;

    await isar?.writeTxn(() async {
      isar?.preferences.put(preference);
    });
  }

  Future<void> setTime(DateTime newTime) async {
    if (isar == null) await _init();

    final prefs = await preferences() ?? Preferences();

    final preference = prefs..time = newTime;

    await isar?.writeTxn(() async {
      isar?.preferences.put(preference);
    });
  }

  Future<void> setGoal(double newGoal) async {
    if (isar == null) await _init();

    final prefs = await preferences() ?? Preferences();

    final preference = prefs..goal = newGoal;

    await isar?.writeTxn(() async {
      isar?.preferences.put(preference);
    });
  }
}

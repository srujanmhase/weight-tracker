import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weight_tracker/models/preferences.dart';
import 'package:weight_tracker/models/weight.dart';
import 'package:weight_tracker/repositories/extensions.dart';

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

  Future<bool> areWeightsInitialized() async {
    if (isar == null) await _init();

    final weights = await isar?.weights.count() ?? 0;

    return weights > 5;
  }

  Future<List<Weight>> weights() async {
    final result = await isar?.weights.where().findAll();

    return result ?? [];
  }

  late final Stream<void>? preferenceStream = isar?.preferences.watchLazy();

  late final Stream<void>? weightsStream = isar?.weights.watchLazy(
    fireImmediately: true,
  );

  Future<void> addOrUpdateWeight(double weight, DateTime day) async {
    if (isar == null) await _init();

    final existingWeight = await weightOnDay(day) ?? Weight()
      ..day = day.woTime();

    existingWeight.weight = weight;
    await isar?.writeTxn(() async {
      isar?.weights.put(existingWeight);
    });
  }

  Future<Weight?> weightOnDay(DateTime day) async {
    final result =
        await isar?.weights.filter().dayEqualTo(day.woTime()).findFirst();

    return result;
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

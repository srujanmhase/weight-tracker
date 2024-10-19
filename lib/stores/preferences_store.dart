import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:weight_tracker/repositories/db.dart';
import 'package:weight_tracker/repositories/di.dart';
import 'package:weight_tracker/repositories/extensions.dart';

class PreferencesStore {
  DatabaseService get db => getIt<DatabaseService>();

  void Function(String?)? onNameUpdate;
  void Function(String?)? onGoalsUpdate;
  VoidCallback? onPop;

  void init() async {
    final pref = await db.preferences();

    final weightsExist = await db.areWeightsInitialized();

    setName(pref?.name);
    setGoal(pref?.goal.toString());

    onNameUpdate?.call(pref?.name);
    onGoalsUpdate?.call((pref?.goal ?? '').toString());

    if (pref?.time == null) {
      await db.setTime(DateTime.now());
    }

    if (!weightsExist) {
      final today = DateTime.now().woTime();

      for (int i = 0; i <= 90; i++) {
        await db.addOrUpdateWeight(-1, today.subtract(Duration(days: i)));
      }
    }
  }

  final Observable<String?> name = Observable('');
  final Observable<String?> goal = Observable('');

  final Observable<bool> canPop = Observable(false);

  void setName(String? name) {
    runInAction(() => this.name.value = name);
  }

  void setGoal(String? goal) {
    runInAction(() => this.goal.value = goal);
  }

  late final Computed<bool> isValidState = Computed(
    () => !([
      (name.value ?? '').isEmpty,
      double.tryParse(goal.value ?? '') == null
    ].any((e) => e == true)),
  );

  void finalize() async {
    if (!isValidState.value) return;

    await db.setName(name.value!);
    await db.setGoal(double.tryParse(goal.value ?? '') ?? 0);

    runInAction(() => canPop.value = true);

    onPop?.call();
  }
}

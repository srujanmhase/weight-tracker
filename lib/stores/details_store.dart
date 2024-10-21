import 'dart:async';
import 'dart:math' as math;

import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:weight_tracker/repositories/db.dart';
import 'package:weight_tracker/repositories/di.dart';
import 'package:weight_tracker/repositories/extensions.dart';
import 'package:weight_tracker/stores/app_store.dart';
import 'package:weight_tracker/stores/days_list_store.dart';

class DetailsStore implements Disposable {
  DetailsStore({
    required this.appStore,
    required this.daysListStore,
  });

  final DaysListStore daysListStore;
  final AppStore appStore;

  DatabaseService get db => getIt<DatabaseService>();

  late final Computed<int> _currentPage =
      Computed(() => daysListStore.currentPage.value.toInt());

  late final Computed<double> activeWeight = Computed(
    () {
      if (_currentPage.value == -1 || appStore.weights.value.isEmpty) return -1;
      return appStore.weights.value[_currentPage.value].weight ?? -1;
    },
  );

  late final Computed<double> _prevWeight = Computed(
    () {
      if (_currentPage.value == -1 || appStore.weights.value.isEmpty) return -1;
      return appStore.weights.value[_currentPage.value + 1].weight ?? -1;
    },
  );

  late final Computed<DateTime> _activeDay = Computed(
    () {
      if (_currentPage.value == -1 || appStore.weights.value.isEmpty) {
        return DateTime.now().woTime();
      }
      return appStore.weights.value[_currentPage.value].day ??
          DateTime.now().woTime();
    },
  );

  late final Computed<String> activeDay = Computed(
    () => _activeDay.value == DateTime.now().woTime()
        ? 'Today'
        : DateFormat(DateFormat.MONTH_DAY).format(
            _activeDay.value,
          ),
  );

  late final Computed<bool> hasAdded = Computed(() => activeWeight.value > -1);

  late final Computed<bool> hasAddedToday = Computed(
    () {
      if (appStore.weights.value.isEmpty) return false;
      return appStore.weights.value.first.day == DateTime.now().woTime() &&
          (appStore.weights.value.first.weight ?? -1) > -1;
    },
  );

  late final Computed<String> summary = Computed(() {
    if (!hasAdded.value) return '';
    if (_prevWeight.value == -1) return '';

    final diff = activeWeight.value - _prevWeight.value;
    final changeType = diff > 0 ? 'higher' : 'lower';
    if (diff == 0) return 'Your weight has not changed since the day before';
    return '${diff.abs().toStringAsFixed(2)}Kg $changeType than the day before';
  });

  late final Computed<String> addHint = Computed(() {
    return '${hasAdded.value ? 'Edit' : 'Add'} your weight for ${activeDay.value}';
  });

  late final Computed<List<double>> avlWeights = Computed(() {
    if (appStore.weights.value.length < 10) return [];

    final weights = appStore.weights.value.getRange(0, 10).toList();

    final avlWeights = weights
        .where((e) => e.weight != -1)
        .map(
          (e) => e.weight ?? 0,
        )
        .toList();

    return avlWeights;
  });

  late final Computed<(double, double)?> tenDayDiff = Computed(() {
    if (avlWeights.value.isEmpty) return null;

    final diff = double.tryParse(
      (avlWeights.value.first - avlWeights.value.last).toStringAsFixed(2),
    );
    final avg = double.tryParse((avlWeights.value.reduce(
              (sum, element) => sum + element,
            ) /
            avlWeights.value.length)
        .toStringAsFixed(2));

    if (diff == null || avg == null) return null;

    return (diff, avg);
  });

  late final Computed<WeightDiff> weightDiff = Computed(
    () => (tenDayDiff.value?.$1 ?? 0) > 0 ? WeightDiff.gained : WeightDiff.lost,
  );

  late final Computed<bool> shouldShowSummary =
      Computed(() => tenDayDiff.value?.$1 != null);

  late final Computed<bool> goalReached = Computed(() {
    if (appStore.weights.value.isEmpty) return false;

    final latest = appStore.weights.value.first.weight;
    final goal = appStore.goal.value;

    if (latest == -1 || goal == -1) return false;

    return latest == goal;
  });

  void addOrEditWeight(double val) async {
    await db.addOrUpdateWeight(val, _activeDay.value.woTime());
  }

  @override
  FutureOr onDispose() {}
}

enum WeightDiff {
  gained(math.pi),
  lost(0);

  const WeightDiff(this.angle);
  final double angle;
}

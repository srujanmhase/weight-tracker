import 'dart:async';

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
      if (_currentPage.value == -1) return -1;
      return appStore.weights.value[_currentPage.value].weight ?? -1;
    },
  );

  late final Computed<double> _prevWeight = Computed(
    () {
      if (_currentPage.value == -1) return -1;
      return appStore.weights.value[_currentPage.value + 1].weight ?? -1;
    },
  );

  late final Computed<DateTime> _activeDay = Computed(
    () {
      if (_currentPage.value == -1) return DateTime.now().woTime();
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

  late final Computed<String> summary = Computed(() {
    if (!hasAdded.value) return '';
    if (_prevWeight.value == -1) return '';

    final diff = activeWeight.value - _prevWeight.value;
    final changeType = diff > 0 ? 'higher' : 'lower';
    if (diff == 0) return 'Your weight has not changed since the day before';
    return '${diff.abs()}Kg $changeType than the day before';
  });

  late final Computed<String> addHint = Computed(() {
    return '${hasAdded.value ? 'Edit' : 'Add'} your weight for ${activeDay.value}';
  });

  void addOrEditWeight(double val) async {
    await db.addOrUpdateWeight(val, _activeDay.value.woTime());
  }

  @override
  FutureOr onDispose() {}
}

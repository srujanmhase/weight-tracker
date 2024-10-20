import 'package:mobx/mobx.dart';
import 'package:weight_tracker/models/weight.dart';
import 'package:weight_tracker/stores/app_store.dart';

class DaysListStore {
  DaysListStore(this.appStore);

  final AppStore appStore;

  final Observable<double> _currentPage = Observable(-1);
  final Observable<double> _previousPage = Observable(-1);

  late final Computed<double> currentPage = Computed(
    () => _currentPage.value,
  );
  late final Computed<double> previousPage = Computed(
    () => _previousPage.value,
  );

  late final Computed<List<Weight>> days = Computed(
    () => appStore.weights.value,
  );

  void setCurrentPage(double page) {
    runInAction(() {
      _previousPage.value = currentPage.value;
      _currentPage.value = page;
    });
  }
}

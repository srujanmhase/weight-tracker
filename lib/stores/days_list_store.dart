import 'package:mobx/mobx.dart';
import 'package:weight_tracker/models/weight.dart';
import 'package:weight_tracker/stores/app_store.dart';

class DaysListStore {
  DaysListStore(this.appStore);

  final AppStore appStore;

  final Observable<double> currentPage = Observable(0);
  final Observable<double> previousPage = Observable(0);

  late final Computed<List<Weight>> days = Computed(
    () => appStore.weights.value,
  );

  void setCurrentPage(double page) {
    runInAction(() {
      previousPage.value = currentPage.value;
      currentPage.value = page;
    });
  }
}

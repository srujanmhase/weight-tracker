import 'package:mobx/mobx.dart';

class DaysListStore {
  final Observable<double> currentPage = Observable(0);
  final Observable<double> previousPage = Observable(0);

  final List<int> days = List.generate(90, (i) => i);

  void setCurrentPage(double page) {
    runInAction(() {
      previousPage.value = currentPage.value;
      currentPage.value = page;
    });
  }
}

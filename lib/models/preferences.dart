import 'package:isar/isar.dart';

part 'preferences.g.dart';

@Collection()
class Preferences {
  Id? id;

  String? name;

  DateTime? time;

  double? goal;
}

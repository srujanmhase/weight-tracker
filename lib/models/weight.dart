import 'package:isar/isar.dart';

part 'weight.g.dart';

@Collection()
class Weight {
  Id? id = Isar.autoIncrement;

  double? weight;

  DateTime? day;
}

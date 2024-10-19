extension DateTimeX on DateTime {
  DateTime woTime() => DateTime(year, month, day);
}

extension MonthX on int {
  String get monthOfYear => switch (this) {
        1 => 'jan',
        2 => 'feb',
        3 => 'mar',
        4 => 'apr',
        5 => 'may',
        6 => 'jun',
        7 => 'jul',
        8 => 'aug',
        9 => 'sep',
        10 => 'oct',
        11 => 'nov',
        12 => 'dec',
        _ => '',
      };
}

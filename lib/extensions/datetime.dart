import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String get dateFormattedString {
    return DateFormat('dd MMM y').format(this);
  }
}
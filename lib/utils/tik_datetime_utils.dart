import 'package:intl/intl.dart';

class TikDateTimeUtils {
  static String get currentDay {
    DateTime now = DateTime.now();
    return DateFormat('EEEE').format(now);
  }

  static String get currentMonth {
    DateTime now = DateTime.now();
    return DateFormat('MMM').format(now);
  }

  static String get currentDate {
    DateTime now = DateTime.now();
    return DateFormat('d').format(now);
  }
}

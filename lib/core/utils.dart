import 'package:intl/intl.dart';

class UtilsHelper {
  static String formatDate(DateTime date,String format) {
    final formatter = DateFormat(format);
    return formatter.format(date);
  }
  static bool areDatesSame(DateTime date1, DateTime date2) {
    return DateTime(date1.year, date1.month, date1.day)
        .isAtSameMomentAs(DateTime(date2.year, date2.month, date2.day));
  }
}

import 'package:intl/intl.dart';

class TimeUtility {
  static String getTime(String timestamp) {
    DateTime tempDate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").parse(timestamp);
    return DateFormat('dd/MM/yyyy hh:mm a').format(tempDate);
  }
}
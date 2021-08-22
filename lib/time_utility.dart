import 'package:intl/intl.dart';

class TimeUtility {
  static String getTime(String timestamp) {
    try {
      DateTime tempDate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").parse(timestamp, true).toLocal();
      return DateFormat('dd/MM/yyyy hh:mm a').format(tempDate);
    } catch (e) {
      return 'null here';
    }
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

class Convertor {
  static Set<String> getStringSet(dynamic data) {
    Set<String> result = {};
    if (data is Iterable) {
      result = data.map((e) => e.toString()).toSet();
    }
    return result;
  }

  static DateTime getDateTime(dynamic data) {
    late DateTime dateTime;
    if (data is String) {
      dateTime = DateTime.parse(data);
    } else if (data is Timestamp) {
      dateTime = data.toDate();
    } else {
      throw const FormatException(
        "DateTime parsing failed. Expected ISO8601 String or Timestamp",
      );
    }
    return dateTime;
  }
}

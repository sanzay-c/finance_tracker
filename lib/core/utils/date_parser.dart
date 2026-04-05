import 'package:cloud_firestore/cloud_firestore.dart';

class DateParser {
  static DateTime parse(dynamic dateField) {
    if (dateField == null) {
      return DateTime.now();
    }
    if (dateField is Timestamp) {
      return dateField.toDate();
    }
    if (dateField is String) {
      try {
        return DateTime.parse(dateField);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateUtils {

  static String getCurrentDate() {
    final DateTime currentDate = DateTime.now();
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    return dateFormat.format(currentDate);
  }

  static String getSelectedDate() {
    final DateTime selectedDate = DateTime.now();
    return DateFormat('dd-MM-yyyy').format(selectedDate);
  }
}

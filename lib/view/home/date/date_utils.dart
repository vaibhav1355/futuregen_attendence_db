import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateUtils {

  static String getCurrentDateFormatted() {
    final DateTime currentDate = DateTime.now();
    return DateFormat('dd-MM-yyyy').format(currentDate);
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  static DateTime parseFormattedDate(String formattedDate) {
    return DateFormat('dd-MM-yyyy').parse(formattedDate);
  }

}

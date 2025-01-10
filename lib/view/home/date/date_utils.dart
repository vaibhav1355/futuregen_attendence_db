import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateUtils {
  static int totalDays = 0;
  static int totalHours = 0;
  static int leftHours = 0;
  static int leftMinutes = 0;
  static double leftDays = 0.0;

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

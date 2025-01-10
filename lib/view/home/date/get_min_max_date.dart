import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GetMinMaxDates {

  static DateTime minDate(List<Map<String, dynamic>> updatedData) {
    return updatedData
        .map((data) => DateFormat('dd-MM-yyyy').parse(data['startDate']))
        .reduce((a, b) => a.isBefore(b) ? a : b);
  }

  static DateTime maxDate(List<Map<String, dynamic>> updatedData) {
    return updatedData
        .map((data) => DateFormat('dd-MM-yyyy').parse(data['endDate']))
        .reduce((a, b) => a.isAfter(b) ? a : b);
  }
}

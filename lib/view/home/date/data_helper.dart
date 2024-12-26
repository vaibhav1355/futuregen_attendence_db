import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DataHelper {
  int daysBetween(DateTime start, DateTime end) => end.difference(start).inDays;

  void updateTotals({
    required List<Map<String, dynamic>> updatedData,
    required DateTime selectedDate,
    required Function(int totalDays, double totalHours, double leftHours, double leftDays) updateState,
  }) {
    try {
      for (var range in updatedData) {
        DateTime rangeStartDate = DateFormat('dd-MM-yyyy').parse(range['startDate']);
        DateTime rangeEndDate = DateFormat('dd-MM-yyyy').parse(range['endDate']);

        int totalUsedMinutes = 0;

        for (var entry in range['entries']) {
          for (var item in entry['categorylist']) {
            final timeParts = item['time'].split(':');
            if (timeParts.length == 2) {
              totalUsedMinutes += (int.tryParse(timeParts[0]) ?? 0) * 60;
              totalUsedMinutes += int.tryParse(timeParts[1]) ?? 0;
            }
          }
        }

        int totalUsedHours = totalUsedMinutes ~/ 60;
        totalUsedMinutes %= 60;

        int rangeDays = daysBetween(rangeStartDate, rangeEndDate) + 1;
        double rangeTotalHours = rangeDays * 8.0;
        double remainingHours = rangeTotalHours - totalUsedHours - (totalUsedMinutes / 60.0);

        range['totalDays'] = rangeDays;
        range['totalHours'] = rangeTotalHours;
        range['leftHours'] = double.parse(remainingHours.toStringAsFixed(2));
        range['leftDays'] = double.parse((remainingHours / 8.0).toStringAsFixed(2));
      }

      bool dateInRange = false;

      for (var range in updatedData) {
        DateTime rangeStartDate = DateFormat('dd-MM-yyyy').parse(range['startDate']);
        DateTime rangeEndDate = DateFormat('dd-MM-yyyy').parse(range['endDate']);

        if (selectedDate.isAfter(rangeStartDate) &&
            selectedDate.isBefore(rangeEndDate) ||
            selectedDate.isAtSameMomentAs(rangeEndDate) ||
            selectedDate.isAtSameMomentAs(rangeStartDate)) {
          dateInRange = true;

          updateState(
            range['totalDays'],
            range['totalHours'],
            range['leftHours'],
            range['leftDays'],
          );
          break;
        }
      }

      if (!dateInRange) {
        updateState(0, 0.0, 0.0, 0.0);
      }
    } catch (e) {
      print('Error in updateTotals: $e');
    }
  }

  void calculateMinAndMaxDates({
    required List<Map<String, dynamic>> updatedData,
    required Function(DateTime minStartDate, DateTime maxEndDate) updateDates,
  }) {
    final DateFormat dateFormat = DateFormat("dd-MM-yyyy");

    List<DateTime> startDates =
    updatedData.map((data) => dateFormat.parse(data['startDate'] as String)).toList();
    List<DateTime> endDates =
    updatedData.map((data) => dateFormat.parse(data['endDate'] as String)).toList();

    DateTime minStartDate = startDates.reduce((a, b) => a.isBefore(b) ? a : b);
    DateTime maxEndDate = endDates.reduce((a, b) => a.isAfter(b) ? a : b);

    updateDates(minStartDate, maxEndDate);
  }
}

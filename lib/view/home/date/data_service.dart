// import 'package:intl/intl.dart';
//
// class DataManager {
//   final List<Map<String, dynamic>> data;
//
//   DataManager(this.data);
//
//   int calculateDaysBetween(DateTime start, DateTime end) => end.difference(start).inDays;
//
//   void updateTotalDaysAndHours(DateTime selectedDate, Function(Map<String, dynamic>) updateState) {
//     try {
//       for (var range in data) {
//         DateTime rangeStartDate = DateFormat('dd-MM-yyyy').parse(range['startDate']);
//         DateTime rangeEndDate = DateFormat('dd-MM-yyyy').parse(range['endDate']);
//
//         int totalUsedMinutes = 0;
//
//         for (var entry in range['entries']) {
//           for (var item in entry['categorylist']) {
//             final timeParts = item['time'].split(':');
//             if (timeParts.length == 2) {
//               totalUsedMinutes += (int.tryParse(timeParts[0]) ?? 0) * 60;
//               totalUsedMinutes += int.tryParse(timeParts[1]) ?? 0;
//             }
//           }
//         }
//
//         int totalUsedHours = totalUsedMinutes ~/ 60;
//         totalUsedMinutes %= 60;
//
//         int rangeDays = calculateDaysBetween(rangeStartDate, rangeEndDate) + 1;
//         int rangeTotalMinutes = rangeDays * 8 * 60;
//         int remainingMinutes = rangeTotalMinutes - ((totalUsedHours * 60) + totalUsedMinutes);
//         double remainingHours = remainingMinutes / 60.0;
//
//         range['totalDays'] = rangeDays;
//         range['totalHours'] = rangeTotalMinutes ~/ 60;
//         range['leftHours'] = remainingHours.floor();
//         range['leftMinutes'] = remainingMinutes % 60;
//         range['leftDays'] = double.parse((remainingHours / 8.0).toStringAsFixed(2));
//
//         if (selectedDate.isAfter(rangeStartDate) &&
//             selectedDate.isBefore(rangeEndDate) ||
//             selectedDate.isAtSameMomentAs(rangeEndDate) ||
//             selectedDate.isAtSameMomentAs(rangeStartDate)) {
//           updateState(range);
//           break;
//         }
//       }
//     } catch (e) {
//       print('Error in updateTotalDaysAndHours: $e');
//     }
//   }
//
//   void calculatePastContracts(DateTime selectedDate) {
//     final DateFormat dateFormat = DateFormat("dd-MM-yyyy");
//
//     for (var range in data) {
//       try {
//         DateTime rangeEndDate = dateFormat.parse(range['endDate']);
//         range['pastContract'] = selectedDate.isAfter(rangeEndDate);
//       } catch (e) {
//         print('Error parsing date in calculatePastContracts: $e');
//       }
//     }
//   }
//
//   Map<String, DateTime> calculateMinAndMaxDates() {
//     final DateFormat dateFormat = DateFormat("dd-MM-yyyy");
//     List<DateTime> startDates = data.map((entry) => dateFormat.parse(entry['startDate'])).toList();
//     List<DateTime> endDates = data.map((entry) => dateFormat.parse(entry['endDate'])).toList();
//
//     return {
//       'minStartDate': startDates.reduce((a, b) => a.isBefore(b) ? a : b),
//       'maxEndDate': endDates.reduce((a, b) => a.isAfter(b) ? a : b),
//     };
//   }
// }

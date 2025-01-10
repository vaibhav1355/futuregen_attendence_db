import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/contract_transaction_repository.dart';
import '../fetch_category_details_by_date.dart';
import '../show_category_bottom_sheet.dart';


void ensureDataExists(DateTime startDate, DateTime endDate , List<Map<String, dynamic>> updatedData) async {
  const String dateFormat = 'dd-MM-yyyy';

  for (DateTime date = startDate; !date.isAfter(endDate); date = date.add(Duration(days: 1))) {
    String formattedDate = DateFormat(dateFormat).format(date);

    try {
      var fetchedData = await fetchCategoryDetailsByDate(formattedDate);

      if (fetchedData.isEmpty) {

        try {
          final repository = ContractTransactionRepository();
          repository.addCategoryTransaction(
            transaction_date: formattedDate,
            category_id: CategoryBottomSheet.categoryWithIds['Admin-General'] ?? 0,
            journal: '',
            hours: '0:00',
            isLocked: 'false',
          );
          repository.addCategoryTransaction(
            transaction_date: formattedDate,
            category_id: CategoryBottomSheet.categoryWithIds['Academic-General'] ?? 0,
            journal: '',
            hours: '0:00',
            isLocked: 'false',
          );
          repository.addCategoryTransaction(
            transaction_date: formattedDate,
            category_id: CategoryBottomSheet.categoryWithIds['Fundraising-General'] ?? 0,
            journal: '',
            hours: '0:00',
            isLocked: 'false',
          );
        } catch (e) {
          print('Error adding category transaction for $formattedDate: $e');
        }

        var newEntry = {
          'selectedDate': formattedDate,
          'isLocked': false,
          'categorylist': [
            {'category': 'Admin-General', 'time': '0:00', 'journals': ''},
            {'category': 'Academic-General', 'time': '0:00', 'journals': ''},
            {'category': 'Fundraising-General', 'time': '0:00', 'journals': ''},
          ],
        };

        for (var range in updatedData) {
          DateTime rangeStartDate = DateFormat(dateFormat).parse(range['startDate']);
          DateTime rangeEndDate = DateFormat(dateFormat).parse(range['endDate']);

          if (date.isAfter(rangeStartDate.subtract(Duration(days: 1))) &&
              date.isBefore(rangeEndDate.add(Duration(days: 1)))) {
            range['entries'].add(newEntry);
            break;
          }
        }
      }
    } catch (e) {
      print('Error ensuring data for $formattedDate: $e');
    }
  }
}
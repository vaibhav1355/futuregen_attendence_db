import 'package:sqflite/sqflite.dart';

import 'db_helper.dart';

class ContractTransactionRepository {

  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> addCategoryTransaction({
    required String transactionDate,
    required int categoryId,
    String? journal,
    String? isLocked,
    String? hours,
  }) async {
    final dbClient = await _dbHelper.database;

    try {
      final existingEntries = await dbClient.query(
        DatabaseHelper.contractTransaction,
        where: '${DatabaseHelper.transaction_date} = ? AND ${DatabaseHelper.categoryId} = ?',
        whereArgs: [transactionDate, categoryId],
      );

      if (existingEntries.isNotEmpty) {
        final existingEntry = existingEntries.first;

        await dbClient.update(
          DatabaseHelper.contractTransaction,
          {
            if (journal != null) DatabaseHelper.journal: journal,
            if (isLocked != null) DatabaseHelper.isLock: isLocked,
            if (hours != null) DatabaseHelper.hours: hours,
            DatabaseHelper.dateSubmitted: DateTime.now().toIso8601String(),
          },
          where: '${DatabaseHelper.transaction_date} = ? AND ${DatabaseHelper.categoryId} = ?',
          whereArgs: [transactionDate, categoryId],
        );
      } else {
        await dbClient.insert(DatabaseHelper.contractTransaction, {
          DatabaseHelper.transaction_date: transactionDate,
          DatabaseHelper.categoryId: categoryId,
          DatabaseHelper.journal: journal ?? '',
          DatabaseHelper.dateSubmitted: DateTime.now().toIso8601String(),
          DatabaseHelper.submittedBy: 1,
          DatabaseHelper.isLock: isLocked ?? 'false',
          DatabaseHelper.hours: hours ?? '00:00',
          DatabaseHelper.finalSubmit: '',
          DatabaseHelper.contractId: 1,
          DatabaseHelper.syncStatus: 0,
          DatabaseHelper.deviceId: 'YourDeviceID',
        });
      }
    } catch (e) {
      print('Error in addCategoryTransaction: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchCategoryDetailsByDate(String transactionDate) async {
    final dbClient = await _dbHelper.database;
    try {
      return await dbClient.query(
        DatabaseHelper.contractTransaction,
        columns: [
          DatabaseHelper.categoryId,
          DatabaseHelper.hours,
          DatabaseHelper.journal,
          DatabaseHelper.isLock,
        ],
        where: '${DatabaseHelper.transaction_date} = ?',
        whereArgs: [transactionDate],
      );
    } catch (e) {
      print('Error fetching category details for date $transactionDate: $e');
      return [];
    }
  }


  // yeh bhi sahi karna padega
  Future<List<Map<String, dynamic>>> fetchCategoryStartDateEndDate(
      String startDate,
      String endDate,
      ) async {
    final dbClient = await _dbHelper.database;

    try {

      final queryCondition = startDate == endDate
          ? '${DatabaseHelper.transaction_date} = ?'
          : '${DatabaseHelper.transaction_date} BETWEEN ? AND ?';

      final queryArgs = startDate == endDate ? [startDate] : [startDate, endDate];

      final result = await dbClient.query(
        DatabaseHelper.contractTransaction,
        columns: [
          DatabaseHelper.transaction_date,
          DatabaseHelper.categoryId,
          DatabaseHelper.hours,
        ],
        where: queryCondition,
        whereArgs: queryArgs,
      );
      return result;
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }


  // for updating the lock status in db
  Future<void> lockTransactionsByDate({
    required String transactionDate,
    required bool isLocked,
  }) async {
    final dbClient = await _dbHelper.database;
    try {
      final String lockState = isLocked ? 'true' : 'false';
      await dbClient.rawUpdate(
        'UPDATE ${DatabaseHelper.contractTransaction} SET ${DatabaseHelper.isLock} = ? WHERE ${DatabaseHelper.transaction_date} = ?',
        [lockState, transactionDate],
      );
    } catch (e) {
      print('Error in lockTransactionsByDate: $e');
    }
  }
}
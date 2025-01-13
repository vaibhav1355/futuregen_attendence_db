import 'package:sqflite/sqflite.dart';

import 'db_helper.dart';

class ContractTransactionRepository {

  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> addCategoryTransaction({
    required String transaction_date,
    required int category_id,
    String? journal,
    String? isLocked,
    String? hours,
    int? sync_status,
  }) async {
    final dbClient = await _dbHelper.database;

    try {
      final existingEntries = await dbClient.query(
        DatabaseHelper.contractTransaction,
        where: '${DatabaseHelper.transaction_date} = ? AND ${DatabaseHelper.category_id} = ?',
        whereArgs: [transaction_date, category_id],
      );

      if (existingEntries.isNotEmpty) {
        final existingEntry = existingEntries.first;

        await dbClient.update(
          DatabaseHelper.contractTransaction,
          {
            if (journal != null) DatabaseHelper.journal: journal,
            if (isLocked != null) DatabaseHelper.islock : isLocked,
            if (hours != null) DatabaseHelper.hours: hours,
            if (sync_status != null) DatabaseHelper.sync_status: sync_status,
            DatabaseHelper.datesubmitted: DateTime.now().toIso8601String(),
          },
          where: '${DatabaseHelper.transaction_date} = ? AND ${DatabaseHelper.category_id} = ?',
          whereArgs: [transaction_date, category_id],
        );
      } else {
        await dbClient.insert(DatabaseHelper.contractTransaction, {
          DatabaseHelper.transaction_date: transaction_date,
          DatabaseHelper.category_id: category_id,
          DatabaseHelper.journal: journal ?? '',
          DatabaseHelper.datesubmitted: DateTime.now().toIso8601String(),
          DatabaseHelper.submitted_by : 1,
          DatabaseHelper.islock : isLocked ?? 'false',
          DatabaseHelper.hours: hours ?? '00:00',
          DatabaseHelper.finalSubmit: '',
          DatabaseHelper.contractId: 1,
          DatabaseHelper.sync_status: sync_status,
          DatabaseHelper.deviceId: 'YourDeviceID',
        });
      }
    } catch (e) {
      print('Error in addCategoryTransaction: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchCategoryDetailsByDate(String transaction_date) async {
    final dbClient = await _dbHelper.database;
    try {
      return await dbClient.query(
        DatabaseHelper.contractTransaction,
        columns: [
          DatabaseHelper.category_id,
          DatabaseHelper.hours,
          DatabaseHelper.journal,
          DatabaseHelper.islock,
          DatabaseHelper.sync_status,
        ],

        where: '${DatabaseHelper.transaction_date} = ?',
        whereArgs: [transaction_date],
      );
    } catch (e) {
      print('Error fetching category details for date $transaction_date $e');
      return [];
    }
  }


  // for updating the lock status in db
  Future<void> lockTransactionsByDate({
    required String transaction_date,
    required bool isLocked,
  }) async {
    final dbClient = await _dbHelper.database;
    try {
      final String lockState = isLocked ? 'true' : 'false';
      await dbClient.rawUpdate(
        'UPDATE ${DatabaseHelper.contractTransaction} SET ${DatabaseHelper.islock } = ? WHERE ${DatabaseHelper.transaction_date} = ?',
        [lockState, transaction_date],
      );
    } catch (e) {
      print('Error in lockTransactionsByDate: $e');
    }
  }
}
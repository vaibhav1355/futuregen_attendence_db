import 'package:sqflite/sqflite.dart';

import 'db_helper.dart';

class ContractTransactionRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> addCategoryTransaction({
    String? transactionDate,
    int? categoryId,
    String? journal,
    String? isLocked,
    String? hours,
  }) async {
    final dbClient = await _dbHelper.database;

    try {
      final existingEntries = await dbClient.query(
        DatabaseHelper.contractTransaction,
        where: '${DatabaseHelper.transactionDate} = ? AND ${DatabaseHelper.categoryId} = ?',
        whereArgs: [transactionDate, categoryId],
      );

      if (existingEntries.isNotEmpty) {
        await dbClient.update(
          DatabaseHelper.contractTransaction,
          {
            DatabaseHelper.journal: journal,
            DatabaseHelper.isLock: isLocked,
            DatabaseHelper.hours: hours,
            DatabaseHelper.dateSubmitted: DateTime.now().toIso8601String(),
          },
          where: '${DatabaseHelper.transactionDate} = ? AND ${DatabaseHelper.categoryId} = ?',
          whereArgs: [transactionDate, categoryId],
        );
      } else {
        await dbClient.insert(DatabaseHelper.contractTransaction, {
          DatabaseHelper.transactionDate: transactionDate,
          DatabaseHelper.categoryId: categoryId,
          DatabaseHelper.journal: journal,
          DatabaseHelper.dateSubmitted: DateTime.now().toIso8601String(),
          DatabaseHelper.submittedBy: 1,
          DatabaseHelper.isLock: isLocked,
          DatabaseHelper.hours: hours,
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


  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final dbClient = await _dbHelper.database;
    try {
      return await dbClient.query(DatabaseHelper.category);
    } catch (e) {
      print('Error in fetchCategories: $e');
      return [];
    }
  }

  Future<void> lockTransactionsByDate({
    required String transactionDate,
    required bool isLocked,
  }) async {
    final dbClient = await _dbHelper.database;
    try {
      final String lockState = isLocked ? 'true' : 'false';
      await dbClient.rawUpdate(
        'UPDATE ${DatabaseHelper.contractTransaction} SET ${DatabaseHelper.isLock} = ? WHERE ${DatabaseHelper.transactionDate} = ?',
        [lockState, transactionDate],
      );
    } catch (e) {
      print('Error in lockTransactionsByDate: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getContractData() async {
    final db = await openDatabase('/data/user/0/com.example.futurgen_attendance/app_flutter/Attendance.db');
    return await db.query('contracts');
  }

  Future<List<Map<String, dynamic>>> getEntries(DateTime startDate, DateTime endDate) async {
    final db = await openDatabase('/data/user/0/com.example.futurgen_attendance/app_flutter/Attendance.db');
    return await db.query(
      'entries',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
    );
  }

  Future<List<Map<String, dynamic>>> getCategoryDetails(int entryId) async {
    final db = await openDatabase('/data/user/0/com.example.futurgen_attendance/app_flutter/Attendance.db');
    return await db.query(
      'categories',
      where: 'entry_id = ?',
      whereArgs: [entryId],
    );
  }
}

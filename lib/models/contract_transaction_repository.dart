import 'dart:ffi';

import 'db_helper.dart';

class ContractTransactionRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> addCategoryTransaction({
    String? transactionDate,
    String? categoryId,
    String? journal,
    String? isLocked,
    String? hours,
  }) async {
    final dbClient = await _dbHelper.database;

    final existingEntries = await dbClient.query(
      DatabaseHelper.contractTransaction,
      where: '${DatabaseHelper.transactionDate} = ? AND ${DatabaseHelper.categoryId} = ?',
      whereArgs: [transactionDate, categoryId],
    );


      await dbClient.insert(DatabaseHelper.contractTransaction, {
        DatabaseHelper.transactionDate: transactionDate,
        DatabaseHelper.categoryId: categoryId,
        DatabaseHelper.journal: journal,
        DatabaseHelper.dateSubmitted: DateTime.now().toIso8601String(),
        DatabaseHelper.submittedBy: 1,
        DatabaseHelper.isLock: isLocked,
        DatabaseHelper.hours : hours,
        DatabaseHelper.finalSubmit: '',
        DatabaseHelper.contractId: 1,
        DatabaseHelper.syncStatus: 0,
        DatabaseHelper.deviceId: 'YourDeviceID',
      });

  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final dbClient = await _dbHelper.database;
    return await dbClient.query(DatabaseHelper.category);
  }
}

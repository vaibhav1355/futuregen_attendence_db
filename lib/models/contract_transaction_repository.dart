import 'package:sqflite/sqflite.dart';
import 'db_helper.dart';

class ContractTransactionRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> addCategoryTransaction({
    String? transactionDate,
    String? categoryId,
    String? hours,
    String? journal,
    String? isLocked,
  }) async {
    final dbClient = await _dbHelper.database;
    await dbClient.insert(DatabaseHelper.contractTransaction, {
      DatabaseHelper.transactionDate: transactionDate,
      DatabaseHelper.categoryId: categoryId,
      DatabaseHelper.hours: hours,
      DatabaseHelper.journal: journal,
      DatabaseHelper.dateSubmitted: DateTime.now().toIso8601String(),
      DatabaseHelper.submittedBy: 1,
      DatabaseHelper.isLock: isLocked,
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

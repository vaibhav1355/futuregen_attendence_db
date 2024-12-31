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
  }

  Future<void> addOrUpdateTransactionForDate({
    required String transactionDate,
    required List<Map<String, dynamic>> categoryData,
  }) async {
    final dbClient = await _dbHelper.database;

    for (var category in categoryData) {
      int? categoryId = category['categoryId'];
      String? journal = category['journal'];
      String? isLocked = category['isLocked'];
      String? hours = category['hours'];

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
    }
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final dbClient = await _dbHelper.database;
    return await dbClient.query(DatabaseHelper.category);
  }
}

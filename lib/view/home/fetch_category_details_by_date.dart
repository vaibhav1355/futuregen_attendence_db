import 'package:flutter/material.dart';

import '../../models/db_helper.dart';

Future<List<Map<String, dynamic>>> fetchCategoryDetailsByDate(String transactionDate) async {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  final dbClient = await _dbHelper.database;
  try {
    List<Map<String, dynamic>> result = await dbClient.query(
      DatabaseHelper.contractTransaction,
      columns: [
        DatabaseHelper.category_id ,
        DatabaseHelper.hours ,
        DatabaseHelper.journal ,
        DatabaseHelper.islock ,
      ],
      where: '${DatabaseHelper.transaction_date} = ?',
      whereArgs: [transactionDate],
    );

    return result;
  } catch (e) {
    print('Error fetching category details for date $transactionDate: $e');
    return [];
  }
}
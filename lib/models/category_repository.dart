import 'package:flutter/material.dart';
import 'db_helper.dart';


class CategoryRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> addCategory({
    required String categoryName,
  }) async {
    final dbClient = await _dbHelper.database;

    await dbClient.insert(DatabaseHelper.category, {
      DatabaseHelper.categoryName: categoryName,
      DatabaseHelper.active: 1,
      DatabaseHelper.appPinCategory: '',
    });
  }
}
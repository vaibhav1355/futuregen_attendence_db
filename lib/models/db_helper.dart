import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {

  static const databaseName = "Attendance3.db";
  static const databaseVersion = 1;
  static Database? db;

  static const category = 'category';
  static const contractTransaction = 'contract_transaction';

  // category db value
  static const id = 'id';
  static const categoryName = 'categoryName';
  static const active = 'active';
  static const appPinCategory = 'appPinCategory';

  // contract transaction Table
  static const transactionId = 'id';
  static const empid = 'empid';
  static const transaction_date = 'transaction_date';
  static const category_id= 'category_id';
  static const hours = 'hours';
  static const journal = 'journal';
  static const datesubmitted = 'datesubmitted';
  static const submitted_by  = 'submitted_by';
  static const islock  = 'islock';
  static const finalSubmit = 'finalsubmit';
  static const contractId = 'contract_id';
  static const sync_status = 'sync_status';
  static const deviceId = 'deviceId';

  Future<Database> get database async {
    db ??= await initDatabase();
    return db!;
  }

  Future<void> init() async {
    db = await database;
  }

  Future<Database> initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, databaseName);
    print("Database Path: $path");

    if (await databaseExists(path)) {
      print("Database exists");
      return db = await openDatabase(
        path,
        version: databaseVersion,
      );
    } else {
      print("Database does not exist, creating new database...");
      return await openDatabase(
        path,
        version: databaseVersion,
        onCreate: (db, version) async {
          print("Running onCreate...");
          await onCreate(db, version);
          print("Database created and initialized.");
        },
      );
    }
  }

  Future<void> onCreate(Database db, int version) async {
    print('Creating Category Table...');
    await db.execute('''
    CREATE TABLE $category(
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $categoryName TEXT, 
      $active INTEGER,
      $appPinCategory TEXT
    )
  ''');
    print('Category Table Created.');

    print("Creating ContractTransaction Table...");
    await db.execute('''
    CREATE TABLE $contractTransaction(
      $transactionId INTEGER PRIMARY KEY AUTOINCREMENT,
      $empid INTEGER,
      $transaction_date TEXT ,
      $category_id INTEGER,
      $hours TEXT,
      $journal TEXT,
      $datesubmitted TEXT,
      $submitted_by  INTEGER,
      $islock  TEXT,
      $finalSubmit TEXT, 
      $contractId INTEGER,
      $sync_status INTEGER, 
      $deviceId TEXT
    )
  ''');
    print("ContractTransaction Table Created.");
  }

  Future<void> printContractTransactionTable() async {
    final dbClient = await database;
    final List<Map<String, dynamic>> contractData = await dbClient.query(contractTransaction);
    print("Contract Transaction Table Data:");
    contractData.forEach((row) => print(row));
  }

  Future<void> deleteAllData() async {
    final dbClient = await database;

    await dbClient.delete(category);
    print("All data from Category table deleted.");

    await dbClient.delete(contractTransaction);
    print("All data from ContractTransaction table deleted.");
  }

}
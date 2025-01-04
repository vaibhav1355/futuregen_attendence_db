import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {

  static const databaseName = "Attendance2.db";
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
  static const empId = 'empid';
  static const transactionDate = 'transaction_date';
  static const categoryId= 'categoryId';
  static const hours = 'hours';
  static const journal = 'journal';
  static const dateSubmitted = 'datesubmitted';
  static const submittedBy = 'submitted_by';
  static const isLock = 'islock';
  static const finalSubmit = 'finalsubmit';
  static const contractId = 'contract_id';
  static const syncStatus = 'sync_status';
  static const deviceId = 'deviceid';

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
      $empId INTEGER,
      $transactionDate TEXT ,
      $categoryId INTEGER,
      $hours TEXT,
      $journal TEXT,
      $dateSubmitted TEXT,
      $submittedBy INTEGER,
      $isLock TEXT,
      $finalSubmit TEXT, 
      $contractId INTEGER,
      $syncStatus INTEGER, 
      $deviceId TEXT
    )
  ''');
    print("ContractTransaction Table Created.");
  }

  // Future<void> printCategoryTable() async {
  //   final dbClient = await database;
  //   final List<Map<String, dynamic>> categoryData = await dbClient.query(category);
  //   print("Category Table Data:");
  //   categoryData.forEach((row) => print(row));
  // }

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


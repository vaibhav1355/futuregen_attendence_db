import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {

  static const databaseName = "Attendance.db";
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
  static const categoryId = 'category_id';
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
      $transactionDate TEXT,
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

  // Future<void> insertTransactionData() async {
  //   final dbClient = await database;
  //
  //   print("Inserting data into ContractTransaction Table...");
  //   await dbClient.insert(contractTransaction, {
  //     empId: 101,
  //     transactionDate: '2024-12-21',
  //     categoryId: 1,
  //     hours: '8',
  //     journal: 'Worked on project X',
  //     dateSubmitted: '2024-12-21',
  //     submittedBy: 1,
  //     isLock: 0,
  //     finalSubmit: '2024-12-21',
  //     contractId: 5001,
  //     syncStatus: 1,
  //     deviceId: 'Device001',
  //   });
  //   print("Data inserted into ContractTransaction Table.");
  // }

  Future<void> printCategoryTable() async {
    final dbClient = await database;
    final List<Map<String, dynamic>> categoryData = await dbClient.query(category);
    print("Category Table Data:");
    categoryData.forEach((row) => print(row));
  }

  Future<void> printContractTransactionTable() async {
    final dbClient = await database;
    final List<Map<String, dynamic>> contractData = await dbClient.query(contractTransaction);
    print("Contract Transaction Table Data:");
    contractData.forEach((row) => print(row));
  }
}



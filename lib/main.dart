import 'package:flutter/material.dart';

import 'package:futurgen_attendance/view/home/home_page.dart';
import 'package:futurgen_attendance/view/login/login_screen.dart';

import 'models/db_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper db = new DatabaseHelper();
  await db.initDatabase();
  //await db.deleteAllData();
  await printTable();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Attendance App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}


Future<void> printTable() async {
  try {
    DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.init();
    await dbHelper.printContractTransactionTable();
  } catch (e) {
    print("Error printing tables: $e");
  }
}


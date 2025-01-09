import 'package:flutter/material.dart';
import 'package:futurgen_attendance/view/drawer/app_drawer.dart';
import 'package:futurgen_attendance/view/home/display_bottom_date_and_hour.dart';
import 'package:futurgen_attendance/view/home/journal.dart';
import 'package:futurgen_attendance/view/home/show_category_bottom_sheet.dart';
import 'package:intl/intl.dart';

import '../../Constants/constants.dart';
import '../../models/contract_transaction_repository.dart';
import '../../models/db_helper.dart';
import 'category_service.dart';
import 'display_category_list.dart';
import 'locking_and_saving.dart';
import 'no_contract_page.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  static const Map<String, int> categoryWithIds = {
    'Admin-General': 1,
    'Academic-General': 2,
    'Fundraising-General': 3,
    'Marketing-General': 4,
    'Operations-General': 5,
    'Finance-General': 6,
    'HR-General': 7,
    'Research-General': 8,
    'Event Management-General': 9,
    'Customer Service-General': 10,
  };

  final List<Map<String, dynamic>> updatedData = [
    {
      "startDate": "20-12-2024",
      "endDate": "23-12-2024",
      "totalDays": 0,
      "leftDays" : 0.0,
      "totalHours": 0,
      "leftHours": 0,
      "leftMinutes" : 0,
      "pastContract": false,
      "entries": [

      ],
    },
    {
      "startDate": "01-01-2025",
      "endDate": "15-01-2025",
      "totalDays": 0,
      "leftDays" : 0.0,
      "totalHours": 0,
      "leftHours": 0,
      "leftMinutes" : 0,
      "pastContract": false,
      "entries": [

      ],
    },
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final DateTime currentDate = DateTime.now();
  late DateTime selectedDate;

  DateTime? minStartDate;
  DateTime? maxEndDate;

  int totalHours = 0 ;
  int totalDays = 0 ;
  int leftHours = 0 ;
  int leftMinutes = 0 ;
  double leftDays= 0.0 ;

  int currentDayTotalHours = 0 ;
  int currentDayTotalMinutes = 0 ;

  bool contractExist = false ;
  bool isPastContract = false;
  bool isLocked = false;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
    _calculateMinAndMaxDates();
    updateTotalDaysAndHours();
    _checkContractExistence();
    _pastContract();
    _fetchLockStatus();
    _ensureDataExists(minStartDate!,maxEndDate!);
  }

  void updateTotalDaysAndHours() async {
    int _daysBetween(DateTime start, DateTime end) => end.difference(start).inDays;

    try {
      for (var range in updatedData) {
        DateTime rangeStartDate = DateFormat('dd-MM-yyyy').parse(range['startDate']);
        DateTime rangeEndDate = DateFormat('dd-MM-yyyy').parse(range['endDate']);

        List<Map<String, dynamic>> categoryData = await ContractTransactionRepository().fetchCategoryStartDateEndDate(
          range['startDate'],
          range['endDate'],
        );

        int totalUsedMinutes = 0;

        for (var entry in categoryData) {
          if (entry[DatabaseHelper.hours] != null) {
            final timeParts = entry[DatabaseHelper.hours].toString().split(':');
            if (timeParts.length == 2) {
              int hours = int.tryParse(timeParts[0]) ?? 0;
              int minutes = int.tryParse(timeParts[1]) ?? 0;
              totalUsedMinutes += (hours * 60) + minutes;
            } else {
              print('Invalid time format: ${entry[DatabaseHelper.hours]}');
            }
          }
        }

        int totalUsedHours = totalUsedMinutes ~/ 60;
        totalUsedMinutes %= 60;

        int rangeDays = _daysBetween(rangeStartDate, rangeEndDate) + 1;
        int rangeTotalMinutes = rangeDays * 8 * 60; // Assuming 8 hours/day
        int remainingMinutes = rangeTotalMinutes - (totalUsedHours * 60 + totalUsedMinutes);

        setState(() {
          range['totalDays'] = rangeDays;
          range['totalHours'] = rangeTotalMinutes ~/ 60;
          range['leftHours'] = remainingMinutes ~/ 60;
          range['leftMinutes'] = remainingMinutes % 60;
          range['leftDays'] = double.parse(((remainingMinutes / 60.0) / 8.0).toStringAsFixed(2));
        });
      }

      // Check if the selected date falls in any range
      bool dateInRange = false;

      for (var range in updatedData) {
        DateTime rangeStartDate = DateFormat('dd-MM-yyyy').parse(range['startDate']);
        DateTime rangeEndDate = DateFormat('dd-MM-yyyy').parse(range['endDate']);

        if (selectedDate.isAtSameMomentAs(rangeStartDate) ||
            selectedDate.isAtSameMomentAs(rangeEndDate) ||
            (selectedDate.isAfter(rangeStartDate) && selectedDate.isBefore(rangeEndDate))) {
          dateInRange = true;

          setState(() {
            totalDays = range['totalDays'];
            totalHours = range['totalHours'];
            leftHours = range['leftHours'];
            leftMinutes = range['leftMinutes'];
            leftDays = range['leftDays'];
          });
          break; // Exit the loop as we've found the range
        }
      }

      if (!dateInRange) {
        // Reset totals if no range contains the selected date
        setState(() {
          totalDays = 0;
          totalHours = 0;
          leftHours = 0;
          leftMinutes = 0;
          leftDays = 0.0;
        });
      }
    } catch (e, stackTrace) {
      print('Error in updateTotalDaysAndHours: $e');
      print('Stack trace: $stackTrace');
    }
  }

  void _calculateMinAndMaxDates() {
    final DateFormat dateFormat = DateFormat("dd-MM-yyyy");

    List<DateTime> startDates = updatedData.map((data) => dateFormat.parse(data['startDate'] as String)).toList();
    List<DateTime> endDates = updatedData.map((data) => dateFormat.parse(data['endDate'] as String)).toList();

    minStartDate = startDates.reduce((a, b) => a.isBefore(b) ? a : b);
    maxEndDate = endDates.reduce((a, b) => a.isAfter(b) ? a : b);
  }

  void _pastContract() {
    final DateFormat dateFormat = DateFormat("dd-MM-yyyy");

    bool isDateInPastContract = false;

    for (var range in updatedData) {
      try {
        DateTime rangeEndDate = dateFormat.parse(range['endDate'] as String);
        if (selectedDate.isAfter(rangeEndDate)) {
          isDateInPastContract = true;
          range['pastContract'] = true;
        } else {
          range['pastContract'] = false;
        }
      } catch (e) {
        print('Error parsing date in _pastContract: $e');
      }
    }
    setState(() {
      isPastContract = isDateInPastContract;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: minStartDate!,
      lastDate: currentDate,
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _checkContractExistence();
        updateTotalDaysAndHours();
        _pastContract();
        _fetchLockStatus();
      });
    }
  }

  void _checkContractExistence() {
    final DateFormat dateFormat = DateFormat("dd-MM-yyyy");

    bool dateExistsInAnyRange = false;

    for (var range in updatedData) {
      DateTime rangeStartDate = dateFormat.parse(range['startDate']);
      DateTime rangeEndDate = dateFormat.parse(range['endDate']);

      if (selectedDate.isAfter(rangeStartDate) && selectedDate.isBefore(rangeEndDate) ||
          selectedDate.isAtSameMomentAs(rangeStartDate) ||
          selectedDate.isAtSameMomentAs(rangeEndDate)) {
        dateExistsInAnyRange = true;
        break;
      }
    }

    setState(() {
      contractExist = dateExistsInAnyRange;
    });
  }

  void _ensureDataExists(DateTime startDate, DateTime endDate) async {
    const String dateFormat = 'dd-MM-yyyy';

    for (DateTime date = startDate; !date.isAfter(endDate); date = date.add(Duration(days: 1))) {
      String formattedDate = DateFormat(dateFormat).format(date);

      try {
        var fetchedData = await fetchCategoryDetailsByDate(formattedDate);

        if (fetchedData.isEmpty) {

          try {
            final repository = ContractTransactionRepository();
            repository.addCategoryTransaction(
              transaction_date: formattedDate,
              categoryId: categoryWithIds['Admin-General'] ?? 0,
              journal: '',
              hours: '0:00',
              isLocked: 'false',
            );
            repository.addCategoryTransaction(
              transaction_date: formattedDate,
              categoryId: categoryWithIds['Academic-General'] ?? 0,
              journal: '',
              hours: '0:00',
              isLocked: 'false',
            );
            repository.addCategoryTransaction(
              transaction_date: formattedDate,
              categoryId: categoryWithIds['Fundraising-General'] ?? 0,
              journal: '',
              hours: '0:00',
              isLocked: 'false',
            );
          } catch (e) {
            print('Error adding category transaction for $formattedDate: $e');
          }

          var newEntry = {
            'selectedDate': formattedDate,
            'isLocked': false,
            'categorylist': [
              {'category': 'Admin-General', 'time': '0:00', 'journals': ''},
              {'category': 'Academic-General', 'time': '0:00', 'journals': ''},
              {'category': 'Fundraising-General', 'time': '0:00', 'journals': ''},
            ],
          };

          for (var range in updatedData) {
            DateTime rangeStartDate = DateFormat(dateFormat).parse(range['startDate']);
            DateTime rangeEndDate = DateFormat(dateFormat).parse(range['endDate']);

            if (date.isAfter(rangeStartDate.subtract(Duration(days: 1))) &&
                date.isBefore(rangeEndDate.add(Duration(days: 1)))) {
              range['entries'].add(newEntry);
              break;
            }
          }
        }
      } catch (e) {
        print('Error ensuring data for $formattedDate: $e');
      }
    }
  }

  Map<String, dynamic> _getSelectedDateData() {
    String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);

    var entry = updatedData.firstWhere(
          (range) {
        DateTime rangeStartDate = DateFormat('dd-MM-yyyy').parse(range['startDate']);
        DateTime rangeEndDate = DateFormat('dd-MM-yyyy').parse(range['endDate']);
        DateTime currentDate = DateFormat('dd-MM-yyyy').parse(formattedDate);

        return currentDate.isAfter(rangeStartDate.subtract(Duration(days: 1))) && currentDate.isBefore(rangeEndDate.add(Duration(days: 1)));
      },
      orElse: () {
        String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
        updatedData.add({
          'startDate': formattedDate,
          'endDate': formattedDate,
          'entries': [],
        });
        return updatedData.last;
      },
    );

    return entry['entries'].firstWhere(
          (entry) => entry['selectedDate'] == formattedDate,
      orElse: () {
        var newEntry = {
          'selectedDate': formattedDate,
          'isLocked': false,
          'categorylist': [
            {'category': 'Admin-General', 'time': '0:00', 'journals': ''},
            {'category': 'Academic-General', 'time': '0:00', 'journals': ''},
            {'category': 'Fundraising-General', 'time': '0:00', 'journals': ''},
          ],
        };
        entry['entries'].add(newEntry);
        return newEntry;
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchCategoryDetailsByDate(String transactionDate) async {
    final DatabaseHelper _dbHelper = DatabaseHelper();

    final dbClient = await _dbHelper.database;
    try {
      List<Map<String, dynamic>> result = await dbClient.query(
        DatabaseHelper.contractTransaction,
        columns: [
          DatabaseHelper.categoryId,
          DatabaseHelper.hours,
          DatabaseHelper.journal,
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

  Future<void> _fetchLockStatus() async {
    String transactionDate = DateFormat('dd-MM-yyyy').format(selectedDate);

    try {
      final result = await fetchCategoryDetailsByDate(transactionDate);
      bool locked = result.any((entry) => entry['islock'] == 'true');
      setState(() {
        isLocked = locked;
      });
    } catch (e) {
      print('Error fetching lock status: $e');
    }
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: Icon(Icons.menu, size: 26, color: Colors.white),
        ),
        centerTitle: true,
        title: Text(
          'Home',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      drawer: Drawer(
        child: AppDrawer(),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.075,
            color: Color(0xff323641),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      if (selectedDate.isAfter(minStartDate!)) {
                        selectedDate = selectedDate.subtract(Duration(days: 1));
                        _checkContractExistence();
                        updateTotalDaysAndHours();
                        _pastContract();
                        _fetchLockStatus();
                      }
                    });
                  },
                ),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Text(
                    DateFormat('EEE, dd MMM yyyy').format(selectedDate),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      if (selectedDate.add(Duration(days: 1)).isBefore(
                          DateTime(currentDate.year, currentDate.month, currentDate.day + 1))) {
                        selectedDate = selectedDate.add(Duration(days: 1));
                        _checkContractExistence();
                        updateTotalDaysAndHours();
                        _pastContract();
                        _fetchLockStatus();
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          if (!contractExist) NoContractPage(),
          if(contractExist) ...[
            SizedBoxHeight10,
            DisplayCategoryList(
              isPastContract: isPastContract,
              selectedDate: DateFormat('dd-MM-yyyy').format(selectedDate).toString(),
              updatedData: updatedData,
              updateTotalDaysAndHours: updateTotalDaysAndHours,
              getSelectedDateData: _getSelectedDateData(),
              isLocked: isLocked,
              // fetchCategoryDetailsByDate: fetchCategoryDetailsByDate,
            ),
            if(isPastContract) LockAndSaving(
              onSave: () {
                String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
                print("Data saved for: $formattedDate");
              },
              onLock: () {
                setState(() {
                  isLocked = true;
                  final String transactionDate = DateFormat('dd-MM-yyyy').format(selectedDate);

                  for (var dateRange in updatedData) {
                    final DateTime startDateTime = DateFormat('dd-MM-yyyy').parse(dateRange['startDate']);
                    final DateTime endDateTime = DateFormat('dd-MM-yyyy').parse(dateRange['endDate']);

                    if (startDateTime.isBefore(selectedDate) || startDateTime.isAtSameMomentAs(selectedDate)) {
                      if (endDateTime.isAfter(selectedDate) || endDateTime.isAtSameMomentAs(selectedDate)) {
                        for (var entry in dateRange['entries']) {
                          if (entry['selectedDate'] == DateFormat('dd-MM-yyyy').format(selectedDate)) {
                            entry['isLocked'] = true;
                          }
                        }
                      }
                    }
                  }

                  final repository = ContractTransactionRepository();
                  repository.lockTransactionsByDate(
                    transaction_date: transactionDate,
                    isLocked: true,
                  );
                });
              },
              isLocked : isLocked,
            ),
            DisplayBottomDateAndHour(totalHours: totalHours ,totalDays : totalDays, leftHours: leftHours, leftDays: leftDays, leftMinutes: leftMinutes,),
          ]
        ],
      ),
    );
  }
}
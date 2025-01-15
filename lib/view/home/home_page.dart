import 'package:flutter/material.dart';
import 'package:futurgen_attendance/view/drawer/app_drawer.dart';
import 'package:futurgen_attendance/view/home/date/date_utils.dart';
import 'package:futurgen_attendance/view/home/display_bottom_date_and_hour.dart';
import 'package:futurgen_attendance/view/home/show_category_bottom_sheet.dart';
import 'package:intl/intl.dart';

import '../../Constants/constants.dart';
import '../../models/contract_transaction_repository.dart';
import '../../models/db_helper.dart';
import 'contract_navigation.dart';
import 'date/ensure_date_exists.dart';
import 'display_category_list.dart';
import 'fetch_category_details_by_date.dart';
import 'locking_and_saving.dart';
import 'no_contract_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  final List<Map<String, dynamic>> updatedData = [
    {
      "startDate": "27-12-2024",
      "endDate": "30-12-2024",
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
      "startDate": "08-01-2025",
      "endDate": "20-01-2025",
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

  // final DateTime currentDate = DateTime.now();
  // late DateTime selectedDate;

  bool isLocked = false;

  @override
  void initState() {
    super.initState();
    dateUtils.selectedDate = DateTime(dateUtils.currentDate.year, dateUtils.currentDate.month, dateUtils.currentDate.day);
    updateTotalDaysAndHours();
    _updateContractStatus();
    _fetchLockStatus();
    ensureDataExists(dateUtils.minDate(updatedData)! , dateUtils.maxDate(updatedData)! , updatedData);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateUtils.selectedDate,
      firstDate: dateUtils.minDate(updatedData)!,
      lastDate: dateUtils.currentDate,
    );
    if (picked != null && picked != dateUtils.selectedDate) {
      setState(() {
        dateUtils.selectedDate = picked;
        _updateContractStatus();
        updateTotalDaysAndHours();
        _fetchLockStatus();
      });
    }
  }

  void _updateContractStatus() {
    final DateFormat dateFormat = DateFormat("dd-MM-yyyy");

    bool exists = false;
    bool isPast = false;

    for (var range in updatedData) {
      DateTime rangeStartDate = dateFormat.parse(range['startDate']);
      DateTime rangeEndDate = dateFormat.parse(range['endDate']);

      if (dateUtils.selectedDate.isAfter(rangeEndDate)) {
        range['pastContract'] = true;
        isPast = true;
      } else {
        range['pastContract'] = false;
      }

      if ((dateUtils.selectedDate.isAfter(rangeStartDate) && dateUtils.selectedDate.isBefore(rangeEndDate)) ||
          dateUtils.selectedDate.isAtSameMomentAs(rangeStartDate) ||
          dateUtils.selectedDate.isAtSameMomentAs(rangeEndDate)) {
        exists = true;
      }
    }

    setState(() {
      dateUtils.contractExist = exists;
      dateUtils.isPastContract = isPast;
    });
  }

  void updateTotalDaysAndHours() async {
    int _daysBetween(DateTime start, DateTime end) => end.difference(start).inDays;

    try {
      for (var range in updatedData) {
        DateTime rangeStartDate = DateFormat('dd-MM-yyyy').parse(range['startDate']);
        DateTime rangeEndDate = DateFormat('dd-MM-yyyy').parse(range['endDate']);

        int totalUsedMinutes = 0;

        for (int i = 0; i <= _daysBetween(rangeStartDate, rangeEndDate); i++) {
          String transactionDate = DateFormat('dd-MM-yyyy').format(rangeStartDate.add(Duration(days: i)));

          List<Map<String, dynamic>> categoryData = await fetchCategoryDetailsByDate(transactionDate);

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
        }
        int totalUsedHours = totalUsedMinutes ~/ 60;
        totalUsedMinutes %= 60;

        int rangeDays = _daysBetween(rangeStartDate, rangeEndDate) + 1;
        int rangeTotalMinutes = rangeDays * 8 * 60;
        int remainingMinutes = rangeTotalMinutes - (totalUsedHours * 60 + totalUsedMinutes);

        setState(() {
          range['totalDays'] = rangeDays;
          range['totalHours'] = rangeTotalMinutes ~/ 60;
          range['leftHours'] = remainingMinutes ~/ 60;
          range['leftMinutes'] = remainingMinutes % 60;
          range['leftDays'] = double.parse(((remainingMinutes / 60.0) / 8.0).toStringAsFixed(2));
        });
      }

      bool dateInRange = false;

      for (var range in updatedData) {
        DateTime rangeStartDate = DateFormat('dd-MM-yyyy').parse(range['startDate']);
        DateTime rangeEndDate = DateFormat('dd-MM-yyyy').parse(range['endDate']);

        if (dateUtils.selectedDate.isAtSameMomentAs(rangeStartDate) ||
            dateUtils.selectedDate.isAtSameMomentAs(rangeEndDate) ||
            (dateUtils.selectedDate.isAfter(rangeStartDate) && dateUtils.selectedDate.isBefore(rangeEndDate))) {
          dateInRange = true;

          setState(() {
            dateUtils.totalDays = range['totalDays'];
            dateUtils.totalHours = range['totalHours'];
            dateUtils.leftHours = range['leftHours'];
            dateUtils.leftMinutes = range['leftMinutes'];
            dateUtils.leftDays = range['leftDays'];
          });
          break;
        }
      }

      if (!dateInRange) {
        setState(() {
          dateUtils.totalDays = 0;
          dateUtils.totalHours = 0;
          dateUtils.leftHours = 0;
          dateUtils.leftMinutes = 0;
          dateUtils.leftDays = 0.0;
        });
      }
    } catch (e, stackTrace) {
      print('Error in updateTotalDaysAndHours: $e');
      print('Stack trace: $stackTrace');
    }
  }

  Future<void> _fetchLockStatus() async {
    String transactionDate = DateFormat('dd-MM-yyyy').format(dateUtils.selectedDate);

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
        actions: [
          TextButton.icon(
            onPressed: () async {
              final repository = ContractTransactionRepository();
              final jsonResponse = await repository.fetchEntriesWithSyncStatus();
              print('Fetched entries: $jsonResponse');
            },
            icon: Icon(Icons.sync, color: Colors.white),
            label: Text(
              'Sync Data',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: Colors.black,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: AppDrawer(),
      ),
      body: Column(
        children: [
          ContractNavigation(
            selectedDate: dateUtils.selectedDate,
            onPrevious: () {
              setState(() {
                if (dateUtils.selectedDate.isAfter(dateUtils.minDate(updatedData)!)) {
                  dateUtils.selectedDate = dateUtils.selectedDate.subtract(Duration(days: 1));
                    updateTotalDaysAndHours();
                    _updateContractStatus();
                    _fetchLockStatus();
                }
              });
            },
            onNext: () {
              setState(() {
                if (dateUtils.selectedDate.add(Duration(days: 1)).isBefore(
                    DateTime(dateUtils.currentDate.year, dateUtils.currentDate.month, dateUtils.currentDate.day + 1))) {
                  dateUtils.selectedDate = dateUtils.selectedDate.add(Duration(days: 1));
                  _updateContractStatus();
                  updateTotalDaysAndHours();
                  _fetchLockStatus();
                }
              });
            },
            onSelectDate: () {
              _selectDate(context);
            },
          ),
          if (!dateUtils.contractExist) NoContractPage(),
          if(dateUtils.contractExist) ...[
            SizedBoxHeight10,
            DisplayCategoryList(
              isPastContract: dateUtils.isPastContract,
              selectedDate: DateFormat('dd-MM-yyyy').format(dateUtils.selectedDate).toString(),
              updatedData: updatedData,
              updateTotalDaysAndHours: updateTotalDaysAndHours,
              isLocked: isLocked,
            ),
            if(dateUtils.isPastContract) LockAndSaving(
              onSave: () {
                String formattedDate = DateFormat('dd-MM-yyyy').format(dateUtils.selectedDate);
                print("Data saved for: $formattedDate");
              },
              onLock: () {
                setState(() {
                  isLocked = true;
                  final String transactionDate = DateFormat('dd-MM-yyyy').format(dateUtils.selectedDate);

                  for (var dateRange in updatedData) {
                    final DateTime startDateTime = DateFormat('dd-MM-yyyy').parse(dateRange['startDate']);
                    final DateTime endDateTime = DateFormat('dd-MM-yyyy').parse(dateRange['endDate']);

                    if (startDateTime.isBefore(dateUtils.selectedDate) || startDateTime.isAtSameMomentAs(dateUtils.selectedDate)) {
                      if (endDateTime.isAfter(dateUtils.selectedDate) || endDateTime.isAtSameMomentAs(dateUtils.selectedDate)) {
                        for (var entry in dateRange['entries']) {
                          if (entry['selectedDate'] == DateFormat('dd-MM-yyyy').format(dateUtils.selectedDate)) {
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
            DisplayBottomDateAndHour(totalHours: dateUtils.totalHours ,totalDays : dateUtils.totalDays, leftHours: dateUtils.leftHours, leftDays: dateUtils.leftDays, leftMinutes: dateUtils.leftMinutes),
          ]
        ],
      ),
    );
  }
}

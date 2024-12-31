import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:futurgen_attendance/view/drawer/app_drawer.dart';
import 'package:futurgen_attendance/view/home/display_bottom_date_and_hour.dart';
import 'package:futurgen_attendance/view/home/journal.dart';
import 'package:futurgen_attendance/view/home/show_category_bottom_sheet.dart';
import 'package:intl/intl.dart';

import '../../Constants/constants.dart';

import '../../models/contract_transaction_repository.dart';
import '../../models/db_helper.dart';
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
      "startDate": "10-12-2024",
      "endDate": "13-12-2024",
      "totalDays": 0,
      "leftDays" : 0.0,
      "totalHours": 0,
      "leftHours": 0,
      "leftMinutes" : 0,
      "pastContract": false,
      "entries": [
        {
          "selectedDate": "11-12-2024",
          "isLocked": false,
          "categorylist": [
            {'category': 'Admin-General', 'time': '2:00', 'journals': 'yeh pehla se likha hoya h Sir Ji '},
            {'category': 'Academic-General', 'time': '2:00', 'journals': 'systummmmm '},
            {'category': 'Customer Service-General', 'time': '2:00', 'journals': 'jai baba ki'},
            {'category': 'Marketing-General', 'time': '2:00', 'journals': ''},
          ],
        },
        {
          "selectedDate": "12-12-2024",
          "isLocked": false,
          "categorylist": [
            {'category': 'Admin-General', 'time': '01:55', 'journals': 'yeh pehla se likha hoya h Sir Ji'},
            {'category': 'Academic-General', 'time': '01:00', 'journals': 'systummmmm'},
            {'category': 'Customer Service-General', 'time': '01:00', 'journals': 'JAI SHREE RAM!'},
            {'category': 'Marketing-General', 'time': '01:00', 'journals': 'systummmm!!'},
          ],
        },
      ],
    },
    {
      "startDate": "20-12-2024",
      "endDate": "10-01-2025",
      "totalDays": 0,
      "leftDays" : 0.0,
      "totalHours": 0,
      "leftHours": 0,
      "leftMinutes" : 0,
      "pastContract": false,
      "entries": [
        {
          "selectedDate": "31-12-2024",
          "isLocked": false,
          "categorylist": [
            {'category': 'Admin-General', 'time': '02:25', 'journals': ''},
            {'category': 'Academic-General', 'time': '02:15', 'journals': ''},
            {'category': 'Customer Service-General', 'time': '01:15', 'journals': ''},
            {'category': 'Marketing-General', 'time': '01:20', 'journals': ''},
          ],
        },
        {
          "selectedDate": "30-12-2024",
          "isLocked": false,
          "categorylist": [
            {'category': 'Admin-General', 'time': '01:15', 'journals': ''},
            {'category': 'Academic-General', 'time': '01:20', 'journals': ''},
            {'category': 'Customer Service-General', 'time': '1:20', 'journals': ''},
            {'category': 'Marketing-General', 'time': '01:45', 'journals': ''},
          ],
        },
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
  double leftDays= 0.0;

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
    _ensureDateExists();
    _pastContract();
  }

  void updateTotalDaysAndHours() {
    int _daysBetween(DateTime start, DateTime end) => end.difference(start).inDays;
    try {
      for (var range in updatedData) {
        DateTime rangeStartDate = DateFormat('dd-MM-yyyy').parse(range['startDate']);
        DateTime rangeEndDate = DateFormat('dd-MM-yyyy').parse(range['endDate']);

        int totalUsedMinutes = 0;

        for (var entry in range['entries']) {
          for (var item in entry['categorylist']) {
            final timeParts = item['time'].split(':');
            if (timeParts.length == 2) {
              totalUsedMinutes += (int.tryParse(timeParts[0]) ?? 0) * 60;
              totalUsedMinutes += int.tryParse(timeParts[1]) ?? 0;
            }
          }
        }

        int totalUsedHours = totalUsedMinutes ~/ 60;
        totalUsedMinutes %= 60;

        int rangeDays = _daysBetween(rangeStartDate, rangeEndDate) + 1;

        int rangeTotalMinutes = rangeDays * 8 * 60;
        int remainingMinutes = rangeTotalMinutes - ((totalUsedHours * 60)+ totalUsedMinutes);

        double remainingHours = remainingMinutes / 60.0;

        setState(() {
          range['totalDays'] = rangeDays;
          range['totalHours'] = rangeTotalMinutes ~/ 60;
          range['leftHours'] = remainingHours.floor();
          range['leftMinutes'] = remainingMinutes % 60;
          range['leftDays'] = double.parse((remainingHours / 8.0).toStringAsFixed(2));
        });

      }
      bool dateInRange = false;

      for (var range in updatedData) {
        DateTime rangeStartDate = DateFormat('dd-MM-yyyy').parse(range['startDate']);
        DateTime rangeEndDate = DateFormat('dd-MM-yyyy').parse(range['endDate']);

        if (selectedDate.isAfter(rangeStartDate) &&
            selectedDate.isBefore(rangeEndDate) || selectedDate.isAtSameMomentAs(rangeEndDate) || selectedDate.isAtSameMomentAs(rangeStartDate)) {
          dateInRange = true;

          setState(() {
            totalDays = range['totalDays'];
            totalHours = range['totalHours'];
            leftHours = range['leftHours'];
            leftMinutes = range['leftMinutes'];
            leftDays = range['leftDays'];
          });
        }
      }
      if (!dateInRange) {
        setState(() {
          totalDays = 0;
          totalHours = 0;
          leftHours = 0;
          leftMinutes = 0;
          leftDays = 0.0;
        });

        print('No matching range found for selectedDate $selectedDate');
      }
    } catch (e) {
      print('Error in updateTotalDaysAndHours: $e');
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
        _ensureDateExists();
        updateTotalDaysAndHours();
        _pastContract();
      });
    }
  }

  Future<void> _selectTime(BuildContext context, int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 0, minute: 0),
      initialEntryMode: TimePickerEntryMode.dial,
    );

    if (picked != null) {
      setState(() {
        // Format the picked time and selected date
        final String formattedTime = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
        final String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);

        // Iterate through the updatedData ranges
        for (var range in updatedData) {
          DateTime rangeStartDate = DateFormat('dd-MM-yyyy').parse(range['startDate']);
          DateTime rangeEndDate = DateFormat('dd-MM-yyyy').parse(range['endDate']);

          // Check if the selected date falls within the current range
          if ((selectedDate.isAfter(rangeStartDate) && selectedDate.isBefore(rangeEndDate)) ||
              selectedDate.isAtSameMomentAs(rangeStartDate) ||
              selectedDate.isAtSameMomentAs(rangeEndDate)) {
            for (var entry in range['entries']) {
              // Check if the entry matches the selected date
              if (entry['selectedDate'] == formattedDate) {
                final categoryList = entry['categorylist'];
                if (index < categoryList.length) {
                  // Update the time for the specific category
                  categoryList[index]['time'] = formattedTime;

                  // Fetch the category name and corresponding ID
                  final String category = categoryList[index]['category'];
                  final int? categoryId = categoryWithIds[category];

                  // Add the category transaction to the repository
                  if (categoryId != null) {
                    try {
                      final repository = ContractTransactionRepository();
                      repository.addCategoryTransaction(
                        transactionDate: DateFormat('yyyy-MM-dd').format(selectedDate),
                        hours: formattedTime,
                        categoryId: categoryId,
                        journal: categoryList[index]['journals'] ?? '',
                        isLocked: entry['isLocked'].toString(),
                      );
                    } catch (e) {
                      print('Error adding transaction: $e');
                    }
                  } else {
                    print('Error: Invalid category ID for $category');
                  }
                  break;
                }
              }
            }
          }
        }
        // Recalculate totals
        updateTotalDaysAndHours();
      });
    }
  }

  void _ensureDateExists() {
    bool dateExists = true;
    for (var range in updatedData) {
      DateTime rangeStartDate = DateFormat('dd-MM-yyyy').parse(range['startDate']);
      DateTime rangeEndDate = DateFormat('dd-MM-yyyy').parse(range['endDate']);

      if (selectedDate.isAfter(rangeStartDate) && selectedDate.isBefore(rangeEndDate) ||
          selectedDate.isAtSameMomentAs(rangeStartDate) || selectedDate.isAtSameMomentAs(rangeEndDate)) {
        if (range['entries'] is! List) {
          range['entries'] = [];
        }

        bool dataExists = range['entries'].any((entry) =>
        entry['selectedDate'] == DateFormat('dd-MM-yyyy').format(selectedDate));

        if (!dataExists) {
          range['entries'].add({
            'selectedDate': DateFormat('dd-MM-yyyy').format(selectedDate),
            'isLocked': false,
            'categorylist': [
              {'category': 'Admin-General', 'time': '0:00', 'journals': ''},
              {'category': 'Academic-General', 'time': '0:00', 'journals': ''},
              {'category': 'Fundraising-General', 'time': '0:00', 'journals': ''},
            ],
          });
        }
        dateExists = false;
        break;
      }
    }

    setState(() {
      contractExist = !dateExists;
    });
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

  void _navigateToJournalScreen(BuildContext context, int index, String category, String initialJournalText) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalScreen(
          index: index,
          category: category,
          initialJournalText: initialJournalText,
          isPastContract: !isPastContract,
          onJournalUpdate: (updatedText) {
            setState(() {
              bool isDateFound = false;
              for (var dateRange in updatedData) {
                final DateTime startDateTime = DateFormat('dd-MM-yyyy').parse(dateRange['startDate']);
                final DateTime endDateTime = DateFormat('dd-MM-yyyy').parse(dateRange['endDate']);

                if ((startDateTime.isBefore(selectedDate) ||
                    startDateTime.isAtSameMomentAs(selectedDate)) &&
                    (endDateTime.isAfter(selectedDate) ||
                        endDateTime.isAtSameMomentAs(selectedDate))) {
                  for (var entry in dateRange['entries']) {
                    if (entry['selectedDate'] == DateFormat('dd-MM-yyyy').format(selectedDate)) {
                      isDateFound = true;

                      for (var categoryObj in entry['categorylist']) {
                        if (categoryObj['category'] == category) {
                          categoryObj['journals'] = updatedText;
                          final repository = ContractTransactionRepository();
                          repository.addCategoryTransaction(
                            transactionDate: DateFormat('yyyy-MM-dd').format(selectedDate),
                            hours: entry['categorylist'][index]['time'],
                            categoryId: categoryWithIds[category] ?? 0,
                            journal: updatedText,
                            isLocked: 'false',
                          );
                          break;
                        }
                      }
                      break;
                    }
                  }
                }
              }
              if (!isDateFound) {
                final repository = ContractTransactionRepository();
                repository.addCategoryTransaction(
                  transactionDate: DateFormat('yyyy-MM-dd').format(selectedDate),
                  categoryId: categoryWithIds[category] ?? 0,
                  journal: updatedText,
                  isLocked: isLocked ? 'true' : 'false',
                );
              }
            });
          },
        ),
      ),
    );
  }

  void _showCategoryBottomSheet(BuildContext context) {
    var selectedDateData = _getSelectedDateData();

    CategoryBottomSheet.showCategoryBottomSheet(
      context: context,
      selectedDateData: selectedDateData,
      selectedDate: selectedDate,
      onCategoryAdded: () {
        setState(() {});
      },
    );
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
                        _ensureDateExists();
                        updateTotalDaysAndHours();
                        _pastContract();
                      }
                    });
                  },
                ),
                InkWell(
                  onTap: () =>_selectDate(context),
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
                        _ensureDateExists();
                        updateTotalDaysAndHours();
                        _pastContract();
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
              selectedDateData: _getSelectedDateData(),
              showCategoryBottomSheet: _showCategoryBottomSheet,
              selectTime: _selectTime,
              navigateToJournalScreen: _navigateToJournalScreen,
              isPastContract: isPastContract,
            ),
            if(isPastContract) LockAndSaving(
              selectedDateData: _getSelectedDateData(),
              onSave: () {
                String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
                print("Data saved for $formattedDate");
              },
              onLock: () {
                final DateTime selectedDateTime = selectedDate;
                setState(() {
                  for (var dateRange in updatedData) {
                    final DateTime startDateTime = DateFormat('dd-MM-yyyy').parse(dateRange['startDate']);
                    final DateTime endDateTime = DateFormat('dd-MM-yyyy').parse(dateRange['endDate']);

                    if (startDateTime.isBefore(selectedDateTime) || startDateTime.isAtSameMomentAs(selectedDateTime)) {
                      if (endDateTime.isAfter(selectedDateTime) || endDateTime.isAtSameMomentAs(selectedDateTime)) {
                        for (var entry in dateRange['entries']) {
                          if (entry['selectedDate'] == DateFormat('dd-MM-yyyy').format(selectedDateTime)) {
                            setState(() {
                              entry['isLocked'] = true;
                              isLocked = true;
                              final repository = ContractTransactionRepository();

                              repository.addCategoryTransaction(
                                journal: '',
                                categoryId: categoryWithIds['category'] ?? 0,
                                transactionDate: DateFormat('yyyy-MM-dd').format(selectedDate),
                                isLocked: isLocked ? 'true' : 'false',
                              );

                            });
                          }
                        }
                      }
                    }
                  }
                });
              },
            ),
            DisplayBottomDateAndHour(totalHours: totalHours ,totalDays : totalDays, leftHours: leftHours, leftDays: leftDays, leftMinutes: leftMinutes,),
          ]
        ],
      ),
    );
  }
}

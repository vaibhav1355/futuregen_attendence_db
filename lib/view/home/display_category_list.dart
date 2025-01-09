import 'dart:async';
import 'package:flutter/material.dart';
import 'package:futurgen_attendance/view/home/show_category_bottom_sheet.dart';
import 'package:intl/intl.dart';
import '../../models/contract_transaction_repository.dart';
import 'journal.dart';

class DisplayCategoryList extends StatefulWidget {

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

  final Map<String, dynamic> getSelectedDateData;
  final List<Map<String, dynamic>> updatedData;
  final bool isPastContract;
  final String selectedDate;
  final void Function() updateTotalDaysAndHours;
  final bool isLocked;

  DisplayCategoryList({
    required this.getSelectedDateData,
    required this.updatedData,
    required this.isPastContract,
    required this.selectedDate,
    required this.updateTotalDaysAndHours,
    required this.isLocked,
  });

  @override
  _DisplayCategoryListState createState() => _DisplayCategoryListState();
}


class _DisplayCategoryListState extends State<DisplayCategoryList> {

  List<Map<String, dynamic>> _categoryDetails = [];

  @override
  void initState() {
    super.initState();
    _fetchCategoryDetails();
  }

  @override
  void didUpdateWidget(DisplayCategoryList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      _fetchCategoryDetails();
    }
  }

  Future<void> _fetchCategoryDetails() async {
    final fetchedData = await ContractTransactionRepository().fetchCategoryDetailsByDate(widget.selectedDate);

    final mappedData = fetchedData.map((item) {
      final categoryName = DisplayCategoryList.categoryWithIds.keys.firstWhere(
            (key) => DisplayCategoryList.categoryWithIds[key] == item['categoryId'],
        orElse: () => 'Unknown Category',
      );

      return {
        'category': categoryName,
        'hours': item['hours'],
        'journal': item['journal'],
        'isLock': item['isLock'],
      };
    }).toList();

    setState(() {
      _categoryDetails = mappedData;
    });
  }

  Future<void> _selectTime(BuildContext context, int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 0, minute: 0),
      initialEntryMode: TimePickerEntryMode.dial,
    );

    if (picked != null) {
      final int hour = picked.hour == 0 ? 12 : picked.hour;
      final String formattedTime = '${hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      final String formattedDate = widget.selectedDate;

      for (var range in widget.updatedData) {
        DateTime rangeStartDate = DateFormat('dd-MM-yyyy').parse(range['startDate']);
        DateTime rangeEndDate = DateFormat('dd-MM-yyyy').parse(range['endDate']);
        DateTime selectedDate = DateFormat('dd-MM-yyyy').parse(formattedDate);
        final category = _categoryDetails[index]['category'];

        final repository = ContractTransactionRepository();

        await repository.addCategoryTransaction(
          transactionDate: formattedDate,
          hours: formattedTime,
          categoryId: DisplayCategoryList.categoryWithIds[category] ?? 0,
        );

        if ((selectedDate.isAfter(rangeStartDate) && selectedDate.isBefore(rangeEndDate)) ||
            selectedDate.isAtSameMomentAs(rangeStartDate) ||
            selectedDate.isAtSameMomentAs(rangeEndDate)) {

          for (var entry in range['entries']) {
            if (entry['selectedDate'] == formattedDate) {
              final categoryList = entry['categorylist'];
              if (index < categoryList.length) {
                categoryList[index]['time'] = formattedTime;
              }
              break;
            }
          }
        }
      }

      setState(() {
        widget.updateTotalDaysAndHours();
        _fetchCategoryDetails();
      });
    }
  }

  void _navigateToJournalScreen(BuildContext context, int index, String category, String initialJournalText) async {
    final DateTime selectedDate = DateFormat('dd-MM-yyyy').parse(widget.selectedDate);
    final formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalScreen(
          index: index,
          category: category,
          initialJournalText: initialJournalText,
          isPastContract: !widget.isPastContract,
          onJournalUpdate: (updatedText) async {
            final repository = ContractTransactionRepository();
            await repository.addCategoryTransaction(
              transactionDate: formattedDate,
              journal: updatedText,
              categoryId: DisplayCategoryList.categoryWithIds[category] ?? 0,
            );
            //bool entryUpdated = false;

            // for (var dateRange in widget.updatedData) {
            //   final DateTime startDate = DateFormat('dd-MM-yyyy').parse(dateRange['startDate']);
            //   final DateTime endDate = DateFormat('dd-MM-yyyy').parse(dateRange['endDate']);
            //
            //   if ((selectedDate.isAfter(startDate) && selectedDate.isBefore(endDate)) ||
            //       selectedDate.isAtSameMomentAs(startDate) ||
            //       selectedDate.isAtSameMomentAs(endDate)) {
            //     for (var entry in dateRange['entries']) {
            //       if (entry['selectedDate'] == formattedDate) {
            //         for (var categoryObj in entry['categorylist']) {
            //           if (categoryObj['category'] == category) {
            //             categoryObj['journals'] = updatedText;
            //
            //             final repository = ContractTransactionRepository();
            //             await repository.addCategoryTransaction(
            //               transactionDate: formattedDate,
            //               hours: categoryObj['time'] ?? '00:00',
            //               categoryId: DisplayCategoryList.categoryWithIds[category] ?? 0,
            //               journal: updatedText,
            //               isLocked: entry['isLocked'].toString(),
            //             );
            //
            //             entryUpdated = true;
            //             break;
            //           }
            //         }
            //       }
            //       if (entryUpdated) break;
            //     }
            //   }
            //   if (entryUpdated) break;
            // }
            //
            // if (!entryUpdated) {
            //   final repository = ContractTransactionRepository();
            //   await repository.addCategoryTransaction(
            //     transactionDate: formattedDate,
            //     hours: '00:00',
            //     categoryId: DisplayCategoryList.categoryWithIds[category] ?? 0,
            //     journal: updatedText,
            //     isLocked: 'false',
            //   );
            // }
            setState(() {
              _fetchCategoryDetails();
            });
          },
          isLocked: widget.isLocked,
        ),
      ),
    );
  } // fix time

  void _showCategoryBottomSheet(BuildContext context) {

    var selectedDateData = widget.getSelectedDateData;
    DateTime formattedDate = DateFormat('dd-MM-yyyy').parse(widget.selectedDate);

    CategoryBottomSheet.showCategoryBottomSheet(
      context: context,
      selectedDateData: selectedDateData,
      selectedDate: formattedDate,
      onCategoryAdded: () async {
        setState(() {
          _fetchCategoryDetails();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLocked = widget.isLocked;
    final showAddItemButton = widget.isPastContract && !isLocked;

    return Expanded(
      child: ListView.builder(
        itemCount: showAddItemButton ? _categoryDetails.length + 1 : _categoryDetails.length,
        itemBuilder: (context, index) {
          if (showAddItemButton && index == _categoryDetails.length) {
            return _buildAddItemButton(context, widget.isLocked);
          }
          final item = _categoryDetails[index];
          return _buildCategoryItem(context, item, index, widget.isLocked);
        },
      ),
    );
  }

  Widget _buildAddItemButton(BuildContext context, bool isLocked) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 4, left: 20.0, bottom: 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () {
                if (!widget.isLocked) {
                  _showCategoryBottomSheet(context);
                }
              },
              child: Image.asset(
                'assets/images/add_img.png',
                height: 50,
                width: 50,
                color: Colors.grey,
                semanticLabel: "Add item",
              ),
            ),
          ),
        ),
        Divider(),
      ],
    );
  }

  Widget _buildCategoryItem(BuildContext context, Map<String, dynamic> item, int index, bool isLocked) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.only(
              left: 30, top: 8, bottom: 8, right: 10),
          leading: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.0),
            child: SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.29,
              child: Text(
                item['category'],
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ),
          title: InkWell(
            onTap: () {
              if (!widget.isLocked && widget.isPastContract) {
                _selectTime(context, index);
              }
            },
            child: Row(
              children: [
                SizedBox(width: 10, height: 50),
                Flexible(
                  child: Text(
                    item['hours'],
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 25, height: 25),
                Image.asset(
                  'assets/images/caret_arrow_up.png',
                  height: 20,
                  width: 20,
                  semanticLabel: "Select time",
                ),
                SizedBox(width: 5, height: 5),
              ],
            ),
          ),
          trailing: ElevatedButton(
            onPressed: () {
              _navigateToJournalScreen(
                context,
                index,
                item['category'],
                item['journal'],
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xffefcd1a),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
              padding: EdgeInsets.all(12),
              minimumSize: Size(110, 38),
            ),
            child: Text(
              'Journal',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff121212),
              ),
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
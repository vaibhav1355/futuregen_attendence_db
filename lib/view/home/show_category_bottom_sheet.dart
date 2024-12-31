import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/contract_transaction_repository.dart';

class CategoryBottomSheet {

  static const List<String> categories = [
    'Admin-General',
    'Academic-General',
    'Fundraising-General',
    'Marketing-General',
    'Operations-General',
    'Finance-General',
    'HR-General',
    'Research-General',
    'Event Management-General',
    'Customer Service-General',
  ];

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

  static void showCategoryBottomSheet({
    required BuildContext context,
    required Map<String, dynamic> selectedDateData,
    required VoidCallback onCategoryAdded,
    required selectedDate,

  }) {
    Map<String, bool> checkboxStates = {};

    selectedDateData['categorylist'].forEach((item) {
      checkboxStates[item['category']] = true;
    });

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.all(4.0),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Color(0xff6C60FF),
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            categories.forEach((category) async {
                              if (checkboxStates[category] == true) {
                                bool isAlreadySelected = selectedDateData['categorylist']
                                    .any((item) => item['category'] == category);
                                if (!isAlreadySelected) {
                                  selectedDateData['categorylist'].add({
                                    'category': category,
                                    'time': '00:00',
                                    'journals': '',
                                  });
                                  String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
                                  final repository = new ContractTransactionRepository();
                                  repository.addCategoryTransaction(
                                    categoryId: categoryWithIds[category] ?? 0,
                                    transactionDate: formattedDate,
                                    hours: '00:00',
                                    isLocked: 'false',
                                    journal: '',
                                  );
                                }
                              }
                            });

                            onCategoryAdded();
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Add Category',
                              style: TextStyle(
                                color: Color(0xff6C60FF),
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        String category = categories[index];
                        bool isChecked = checkboxStates[category] ?? false;

                        bool isAlreadySelected = selectedDateData['categorylist']
                            .any((item) => item['category'] == category);

                        return Column(
                          children: [
                            CheckboxListTile(
                              title: Text(category),
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  if (isAlreadySelected && !(value ?? false)) {
                                    return;
                                  }
                                  checkboxStates[category] = value ?? false;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                            Divider(),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
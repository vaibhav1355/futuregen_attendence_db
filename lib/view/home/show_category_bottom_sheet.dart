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
    required DateTime selectedDate,
  }) async {
    Map<String, bool> checkboxStates = {};
    final repository = ContractTransactionRepository();

    String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
    List<Map<String, dynamic>> existingCategories =
    await repository.fetchCategoryDetailsByDate(formattedDate);

    for (var category in categories) {
      checkboxStates[category] = existingCategories.any((entry) =>
      entry['categoryId'] == categoryWithIds[category] && entry['isLock'] == 'false');
    }

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Padding(
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
                          onTap: () async {
                            for (var category in categories) {
                              if (checkboxStates[category] == true) {
                                bool isAlreadySelected = existingCategories.any((entry) =>
                                entry['categoryId'] == categoryWithIds[category]);

                                if (!isAlreadySelected) {
                                  selectedDateData['categorylist'].add({
                                    'category': category,
                                    'time': '00:00',
                                    'journals': '',
                                  });

                                  await repository.addCategoryTransaction(
                                    categoryId: categoryWithIds[category] ?? 0,
                                    transactionDate: formattedDate,
                                    hours: '00:00',
                                    isLocked: 'false',
                                    journal: '',
                                  );
                                }
                              }
                            }
                            onCategoryAdded();
                            Navigator.pop(context);
                          },
                          child: const Padding(
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
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        String category = categories[index];
                        bool isChecked = checkboxStates[category] ?? false;

                        return Column(
                          children: [
                            CheckboxListTile(
                              title: Text(
                                category,
                                style: TextStyle(
                                  color: existingCategories.any((entry) =>
                                  entry['categoryId'] == categoryWithIds[category])
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                              value: isChecked,
                              onChanged: existingCategories.any((entry) =>
                              entry['categoryId'] == categoryWithIds[category])
                                  ? null
                                  : (bool? value) {
                                setState(() {
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

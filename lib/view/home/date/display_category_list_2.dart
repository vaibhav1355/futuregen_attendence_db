// import 'package:flutter/material.dart';
//
// import '../../../models/contract_transaction_repository.dart';
//
// class DisplayCategoryList extends StatefulWidget {
//
//   static const Map<String, int> categoryWithIds = {
//     'Admin-General': 1,
//     'Academic-General': 2,
//     'Fundraising-General': 3,
//     'Marketing-General': 4,
//     'Operations-General': 5,
//     'Finance-General': 6,
//     'HR-General': 7,
//     'Research-General': 8,
//     'Event Management-General': 9,
//     'Customer Service-General': 10,
//   };
//
//   final String selectedDate;
//   final Function(BuildContext) showCategoryBottomSheet;
//   final Future<void> Function(BuildContext, int) selectTime;
//   final Function(BuildContext, int, String, String) navigateToJournalScreen;
//   final bool isPastContract;
//
//   DisplayCategoryList({
//     required this.selectedDate,
//     required this.showCategoryBottomSheet,
//     required this.selectTime,
//     required this.navigateToJournalScreen,
//     required this.isPastContract,
//   });
//
//   @override
//   _DisplayCategoryListState createState() => _DisplayCategoryListState();
// }
//
// class _DisplayCategoryListState extends State<DisplayCategoryList> {
//   late Future<List<Map<String, dynamic>>> categoryData;
//
//   @override
//   void initState() {
//     super.initState();
//     categoryData = _fetchCategoryData();
//   }
//
//   Future<List<Map<String, dynamic>>> _fetchCategoryData() async {
//     final repository = ContractTransactionRepository();
//     final data = await repository.fetchCategoryDetailsByDate(widget.selectedDate);
//     print('Fetched Data: $data');
//     return data;
//   }
//
//   // Function to map categoryId to category name
//   String getCategoryName(int categoryId) {
//     // Loop through the map to find the category name
//     return DisplayCategoryList.categoryWithIds.entries
//         .firstWhere((entry) => entry.value == categoryId, orElse: () => MapEntry('Unknown Category', 0))
//         .key;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Map<String, dynamic>>>(
//       future: categoryData,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//
//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }
//
//         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return Center(child: Text('No data available.'));
//         }
//
//         final categoryList = snapshot.data!; // The fetched category data
//         print('Category List: $categoryList'); // Debug: Check the actual data passed
//
//         final isLocked = widget.isPastContract; // Adjust the logic if needed
//         final showAddItemButton = widget.isPastContract && !isLocked;
//
//         return Expanded(
//           child: ListView.builder(
//             itemCount: showAddItemButton
//                 ? categoryList.length + 1
//                 : categoryList.length,
//             itemBuilder: (context, index) {
//               if (showAddItemButton && index == categoryList.length) {
//                 return _buildAddItemButton(context, isLocked);
//               }
//
//               final item = categoryList[index];
//               return _buildCategoryItem(context, item, index, isLocked);
//             },
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildAddItemButton(BuildContext context, bool isLocked) {
//     return Column(
//       children: [
//         Padding(
//           padding: EdgeInsets.only(top: 4, left: 20.0, bottom: 4),
//           child: Align(
//             alignment: Alignment.centerLeft,
//             child: InkWell(
//               onTap: () {
//                 if (!isLocked) {
//                   widget.showCategoryBottomSheet(context);
//                 }
//               },
//               child: Image.asset(
//                 'assets/images/add_img.png',
//                 height: 50,
//                 width: 50,
//                 color: Colors.grey,
//                 semanticLabel: "Add item",
//               ),
//             ),
//           ),
//         ),
//         Divider(),
//       ],
//     );
//   }
//
//   Widget _buildCategoryItem(BuildContext context, Map<String, dynamic> item, int index, bool isLocked) {
//     final categoryId = item['categoryId'];
//     final categoryName = getCategoryName(categoryId); // Get the category name
//
//     return Column(
//       children: [
//         ListTile(
//           contentPadding: EdgeInsets.only(left: 30, top: 8, bottom: 8, right: 10),
//           leading: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 6.0),
//             child: SizedBox(
//               width: MediaQuery.of(context).size.width * 0.29,
//               child: Text(
//                 categoryName, // Display category name
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontSize: 17,
//                   fontWeight: FontWeight.w600,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 2,
//               ),
//             ),
//           ),
//           title: InkWell(
//             onTap: () {
//               if (!isLocked && widget.isPastContract) {
//                 widget.selectTime(context, index);
//               }
//             },
//             child: Row(
//               children: [
//                 SizedBox(width: 10, height: 50),
//                 Flexible(
//                   child: Text(
//                     item['hours'] ?? '0:00', // Provide fallback for null
//                     style: TextStyle(
//                       color: Colors.grey,
//                       fontSize: 20,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 25, height: 25),
//                 Image.asset(
//                   'assets/images/caret_arrow_up.png',
//                   height: 20,
//                   width: 20,
//                   semanticLabel: "Select time",
//                 ),
//                 SizedBox(width: 5, height: 5),
//               ],
//             ),
//           ),
//           trailing: ElevatedButton(
//             onPressed: () {
//               if (!isLocked) {
//                 widget.navigateToJournalScreen(
//                   context,
//                   index,
//                   categoryName, // Pass the category name
//                   item['journals'] ?? '', // Handle null case
//                 );
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Color(0xffefcd1a),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(32.0),
//               ),
//               padding: EdgeInsets.all(12),
//               minimumSize: Size(110, 38),
//             ),
//             child: Text(
//               'Journal',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Color(0xff121212),
//               ),
//             ),
//           ),
//         ),
//         Divider(),
//       ],
//     );
//   }
// }

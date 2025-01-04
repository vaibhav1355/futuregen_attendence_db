// import 'dart:async';
// import 'package:flutter/material.dart';
// import '../../models/contract_transaction_repository.dart';
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
//   final Function(BuildContext) showCategoryBottomSheet;
//   final Future<void> Function(BuildContext, int) selectTime;
//   final Function(BuildContext, int, String, String) navigateToJournalScreen;
//   final bool isPastContract;
//   final String selectedDate;
//
//   DisplayCategoryList({
//     required this.showCategoryBottomSheet,
//     required this.selectTime,
//     required this.navigateToJournalScreen,
//     required this.isPastContract,
//     required this.selectedDate,
//   });
//
//   @override
//   _DisplayCategoryListState createState() => _DisplayCategoryListState();
// }
//
//
// class _DisplayCategoryListState extends State<DisplayCategoryList> {
//
//   List<Map<String, dynamic>> _categoryDetails = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchCategoryDetails();
//   }
//
//   @override
//   void didUpdateWidget(DisplayCategoryList oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.selectedDate != oldWidget.selectedDate) {
//       _fetchCategoryDetails();
//     }
//   }
//
//   Future<void> _fetchCategoryDetails() async {
//     final fetchedData = await ContractTransactionRepository().fetchCategoryDetailsByDate(widget.selectedDate);
//
//     final mappedData = fetchedData.map((item) {
//       final categoryName = DisplayCategoryList.categoryWithIds.keys.firstWhere(
//             (key) => DisplayCategoryList.categoryWithIds[key] == item['categoryId'],
//         orElse: () => 'Unknown Category',
//       );
//
//       return {
//         'category': categoryName,
//         'hours': item['hours'],
//         'journal': item['journal'],
//         'isLock': item['isLock'],
//       };
//     }).toList();
//
//     setState(() {
//       _categoryDetails = mappedData;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isLocked = _categoryDetails.every((item) => item['isLock'] == true);
//     final showAddItemButton = widget.isPastContract && !isLocked;
//
//     return Expanded(
//       child: ListView.builder(
//         itemCount: showAddItemButton ? _categoryDetails.length + 1 : _categoryDetails.length,
//         itemBuilder: (context, index) {
//           if (showAddItemButton && index == _categoryDetails.length) {
//             return _buildAddItemButton(context, isLocked);
//           }
//
//           final item = _categoryDetails[index];
//           return _buildCategoryItem(context, item, index, isLocked);
//         },
//       ),
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
//     return Column(
//       children: [
//         ListTile(
//           contentPadding: EdgeInsets.only(left: 30, top: 8, bottom: 8, right: 10),
//           leading: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 6.0),
//             child: SizedBox(
//               width: MediaQuery.of(context).size.width * 0.29,
//               child: Text(
//                 item['category'],
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
//                     item['hours'],
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
//                   item['category'],
//                   item['journal'] ,
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

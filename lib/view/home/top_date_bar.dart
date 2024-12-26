import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DisplayTopDateBar extends StatefulWidget {
  final DateTime selectedDate;
  final DateTime currentDate;
  final DateTime startDate;
  final void Function() ensureDateExists;
  final Future<void> Function(BuildContext) selectDate;

  DisplayTopDateBar({
    required this.selectedDate,
    required this.currentDate,
    required this.startDate,
    required this.ensureDateExists,
    required this.selectDate,
  });

  @override
  State<DisplayTopDateBar> createState() => _DisplayTopDateBarState();
}

class _DisplayTopDateBarState extends State<DisplayTopDateBar> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate;
  }

  void updateDate(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
    });
    widget.ensureDateExists();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.075,
      color: Color(0xff323641),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              final newDate = selectedDate.subtract(Duration(days: 1));
              if (newDate.isAfter(widget.startDate) || newDate.isAtSameMomentAs(widget.startDate)) {
                updateDate(newDate);
              }
            },
          ),
          InkWell(
            onTap: () async {
              await widget.selectDate(context);
              setState(() {
                selectedDate = widget.selectedDate;
              });
            },
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
              final newDate = selectedDate.add(Duration(days: 1));
              if (newDate.isBefore(widget.currentDate.add(Duration(days: 1)))) {
                updateDate(newDate);
              }
            },
          ),
        ],
      ),
    );
  }
}

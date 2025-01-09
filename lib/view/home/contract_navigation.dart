import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContractNavigation extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onSelectDate;

  const ContractNavigation({
    Key? key,
    required this.selectedDate,
    required this.onPrevious,
    required this.onNext,
    required this.onSelectDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      color:  Color(0xff323641),
      height: MediaQuery.of(context).size.height * 0.075,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: onPrevious,
          ),
          InkWell(
            onTap: onSelectDate,
            child: Text(
              DateFormat('EEE, dd MMM yyyy').format(selectedDate),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}

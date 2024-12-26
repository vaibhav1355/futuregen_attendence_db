import 'package:flutter/material.dart';

class NoContractPage extends StatelessWidget {
  const NoContractPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.sizeOf(context).height*0.40),
        Text(
          'No Contract Exist on this date',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
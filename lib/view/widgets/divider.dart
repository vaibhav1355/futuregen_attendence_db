import 'package:flutter/material.dart';

class Divider extends StatelessWidget {
  const Divider({super.key, required int thickness , required color});

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 2,
      color: Color(0xfff1ecf0),
    );
  }
}
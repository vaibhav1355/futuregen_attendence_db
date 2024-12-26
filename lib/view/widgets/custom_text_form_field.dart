import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final IconData? icon;
  final Color?  fillColor;
  final String? Function(String?) validator;
  final TextStyle? labelStyle;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.icon,
    required this.validator,
    this.fillColor,
    this.labelStyle,

  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')), // Deny spaces
      ],
      controller: controller,
      decoration: InputDecoration(
        fillColor: fillColor,
        filled: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        prefixIcon: Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: Icon(icon, color: Color(0xffc7b65a)),
        ),
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: TextStyle(fontSize: 16, color: Colors.white),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff969696), width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff969696), width: 1.5),
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff969696), width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      obscureText: obscureText,
      validator: validator,
      style: TextStyle(color: Colors.white),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:futurgen_attendance/constants/constants.dart';


class ForgotPassword extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0b0b0b),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
        title: Center(
          child: Text(
            'Forgot Password',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBoxHeight80,
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ],
                controller: _emailController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Email Address',
                  hintStyle: TextStyle(
                    color: Colors.black54,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffafafaf), width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffafafaf), width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffafafaf), width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ), // -> aadhar
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBoxHeight80,
              MaterialButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {

                  }
                },
                minWidth: MediaQuery.sizeOf(context).width,
                color: Color(0xff0b0b0b),
                child:  Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    'SEND EMAIL',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


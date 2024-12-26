import 'package:flutter/material.dart';
import 'package:futurgen_attendance/view/home/home_page.dart';

import '../../Constants/constants.dart';
import '../widgets/custom_text_form_field.dart';
import 'forgot_password.dart';

class LoginForm extends StatelessWidget {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: CustomTextFormField(
              fillColor: Color(0xff969696),
              controller: usernameController,
              labelText: "Username",
              icon: Icons.email,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Username cannot be empty';
                }
                String trimmedValue = value.trim();
                if (trimmedValue.length < 6 || trimmedValue.length > 16) {
                  return 'Username must be 6-16 characters long';
                }
                if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(trimmedValue)) {
                  return 'Username must contain only letters and numbers';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: CustomTextFormField(
              fillColor: Color(0xff969696),
              controller: passwordController,
              labelText: "Password",
              obscureText: true,
              icon: Icons.key,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Password cannot be empty';
                }
                if (!RegExp(r'^.{8,32}$').hasMatch(value.trim())) {
                  return 'Password must be 8-32 characters long';
                }
                if (!RegExp(r'^.*[A-Z]').hasMatch(value.trim())) {
                  return 'Password must contain at least one upper case letter';
                }
                if (!RegExp(r'^.*[a-z]').hasMatch(value.trim())) {
                  return 'Password must contain at least one lower case letter';
                }
                if (!RegExp(r'^.*[0-9]').hasMatch(value.trim())) {
                  return 'Password must contain at least one digit';
                }
                if (!RegExp(r'^.*[!@#\$&*~]').hasMatch(value.trim())) {
                  return 'Password must contain at least one Special character';
                }
                return null;
              },
            ),
          ),
          SizedBoxHeight30,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 10),
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgotPassword(),
                      ),
                    );
                  },
                  child: Text(
                    'Forget Password?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBoxHeight25,
          MaterialButton(
              onPressed: (){
                if (_formKey.currentState?.validate() ?? false) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                }
              },
              minWidth: MediaQuery.sizeOf(context).width*0.75,
              color: Color(0xffeacc20),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Sign In',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
          ),
          SizedBoxHeight10,
        ],
      ),
    );
  }
}

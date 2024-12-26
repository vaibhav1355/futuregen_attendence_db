import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import 'google_sign_in_button.dart';
import 'login_form.dart';


class Login extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    final screenHeight = ScreenSize.height(context);
    final screenWidth = ScreenSize.width(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/home_image_1.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.60),
                  Colors.black.withOpacity(0.60),
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'T I M E S H E E T',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 44.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBoxHeight10,
                  Image.asset(
                    'assets/images/grid.png',
                    height: 50,
                    width: 50,
                    color: Colors.white,
                  ),
                  SizedBoxHeight20,
                  LoginForm(),
                  SizedBoxHeight20,
                  GoogleSignInButton(),
                  SizedBoxHeight40,
                  RichText(
                    maxLines: 2,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'FUTURE GENERATIONS\n',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: 'U N I V E R S I T Y',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 54.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

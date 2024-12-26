import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../home/home_page.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  bool isLoading = false;

  Future<void> _handleSignIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
        print("Access Token: ${googleAuth.accessToken}");
        print("User email: ${googleUser.email}");
        print("User display name: ${googleUser.displayName}");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: isLoading ? null : _handleSignIn,
      color: Color(0xff00c15b),
      minWidth: MediaQuery.sizeOf(context).width*0.75,
      padding: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32.0),
      ),
      child: isLoading
          ? SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      )
          : Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/google_transparent.jpg',
            height: 24.0,
            width: 24.0,
          ),
          SizedBox(width: 10),
          Text(
            'Sign in with Google',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xff00431e),
            ),
          ),
        ],
      ),
    );
  }
}

// username must be 6-16 characters
// username
import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Center(
          child: Text('About Us',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'Welcome to FutureGen Attendance',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'We are committed to streamlining attendance management for organizations and educational institutions.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 20),

              // Our Mission
              Text(
                'Our Mission',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'At FutureGen, we aim to provide a seamless, accurate, and efficient way to track attendance. Our goal is to reduce manual effort and improve accountability for both employees and students.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),

              // Key Features Section
              Text(
                'Key Features',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.blueAccent),
                title: Text('Real-time Attendance Tracking'),
              ),
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.blueAccent),
                title: Text('Geolocation-Based Check-ins'),
              ),
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.blueAccent),
                title: Text('Customizable Reporting'),
              ),
              SizedBox(height: 20),

              // Contact Information Section
              Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'For more information, feedback, or support, please reach out to us at:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Email: support@futuregen.com',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueAccent,
                ),
              ),
              Text(
                'Phone: +1 234 567 890',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 20),

              // Footer Section
              Center(
                child: Text(
                  '© 2024 FutureGen Solutions',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black45,
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

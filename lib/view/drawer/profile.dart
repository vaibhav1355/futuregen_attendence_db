import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
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
          child: Text('Profile',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/profile_pic.png'),
              child: Align(
                alignment: Alignment.bottomRight,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: Icon(Icons.camera_alt, color: Colors.white, size: 18),
                    onPressed: () {

                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildProfileField(
              label: 'Name',
              value: 'John Doe',
              icon: Icons.person,
            ),
            SizedBox(height: 12),
            _buildProfileField(
              label: 'Email',
              value: 'john.doe@example.com',
              icon: Icons.email,
            ),
            SizedBox(height: 12),

            _buildProfileField(
              label: 'Phone',
              value: '+1 234 567 890',
              icon: Icons.phone,
            ),
            SizedBox(height: 12),

            _buildProfileField(
              label: 'Address',
              value: '123, Main Street, City, Country',
              icon: Icons.location_on,
            ),
            SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: () {

              },
              icon: Icon(Icons.edit),
              label: Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }
}

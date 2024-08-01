import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),
          SizedBox(height: 20),
          Text(
            'Name: John Doe',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            'Email: john.doe@example.com',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black, 
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: Text(
              'Edit Profile',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

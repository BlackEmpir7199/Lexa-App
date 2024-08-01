import 'package:flutter/material.dart';

class NetworkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Network',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          NetworkCard(name: 'John Doe', status: 'Online', avatar: 'https://via.placeholder.com/150'),
          NetworkCard(name: 'Jane Smith', status: 'Offline', avatar: 'https://via.placeholder.com/150'),
          NetworkCard(name: 'Alice Johnson', status: 'Online', avatar: 'https://via.placeholder.com/150'),
        ],
      ),
    );
  }
}

class NetworkCard extends StatelessWidget {
  final String name;
  final String status;
  final String avatar;

  NetworkCard({required this.name, required this.status, required this.avatar});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white12,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(avatar),
        ),
        title: Text(
          name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: Text(
          status,
          style: TextStyle(color: status == 'Online' ? Colors.green : Colors.red),
        ),
        onTap: () {},
      ),
    );
  }
}

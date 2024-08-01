import 'package:flutter/material.dart';

class ResourcesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resources',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ResourceCard(title: 'Mobile Development', description: 'Learn to build mobile applications using Flutter.'),
          ResourceCard(title: 'Web Development', description: 'Master the art of creating responsive web applications.'),
          ResourceCard(title: 'Machine Learning', description: 'Dive into the world of AI and ML with practical projects.'),
        ],
      ),
    );
  }
}

class ResourceCard extends StatelessWidget {
  final String title;
  final String description;

  ResourceCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white12,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: Text(
          description,
          style: TextStyle(color: Colors.white70),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
        onTap: () {},
      ),
    );
  }
}

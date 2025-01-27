import 'package:flutter/material.dart';

class PackageCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String location;
  final String author;
  final List<String> keywords;

  PackageCard({
    required this.title,
    required this.subtitle,
    required this.location,
    required this.author,
    required this.keywords,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Card(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: SizedBox(
            width: 90,
            height: 90,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://picsum.photos/100',
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  keywords.join(' · '),
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    location,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage('https://picsum.photos/50'),
                  ),
                  SizedBox(width: 8),
                  Text(
                    author,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
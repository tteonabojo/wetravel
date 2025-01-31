import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  final String time;
  final String title;
  final String location;
  final String details;
  final bool isDetailsVisible;
  final VoidCallback onToggleDetails;

  const ScheduleCard({
    required this.time,
    required this.title,
    required this.location,
    required this.details,
    required this.isDetailsVisible,
    required this.onToggleDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(time, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              Text(title, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4.0),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16.0, color: Colors.grey),
                  const SizedBox(width: 4.0),
                  Text(location, style: TextStyle(fontSize: 14.0, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 8.0),
              GestureDetector(
                onTap: onToggleDetails,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('상세 내용', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.grey)),
                    Icon(isDetailsVisible ? Icons.expand_less : Icons.expand_more, color: Colors.grey),
                  ],
                ),
              ),
              if (isDetailsVisible) Padding(padding: const EdgeInsets.only(top: 8.0), child: Text(details)),
            ],
          ),
        ),
      ),
    );
  }
}
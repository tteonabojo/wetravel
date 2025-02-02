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
      padding: const EdgeInsets.only(bottom: 12.0), // 카드들 사이의 간격 12로 설정
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(time, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              Text(title, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4.0),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16.0, color: Colors.grey),
                  const SizedBox(width: 4.0),
                  Text(location, style: const TextStyle(fontSize: 14.0, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 8.0),
              GestureDetector(
                onTap: onToggleDetails,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        isDetailsVisible
                            ? details
                            : '${details.substring(0, details.length > 25 ? 25 : details.length)}...',
                        style: const TextStyle(fontSize: 14.0, color: Colors.black87),
                      ),
                    ),
                    Icon(isDetailsVisible ? Icons.expand_less : Icons.expand_more, color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

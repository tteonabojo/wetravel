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
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 왼쪽 여백을 추가한 이미지
            Padding(
              padding: const EdgeInsets.only(left: 8.0),  // 왼쪽 여백 추가
              child: ClipRRect(
                borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
                child: Image.network(
                  'https://picsum.photos/150',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // 오른쪽 텍스트 영역
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 제목
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    // 키워드
                    Text(
                      keywords.join(' · '),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    // 위치
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.red, size: 16),
                        SizedBox(width: 4),
                        Text(
                          location,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    // 작성자
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundImage:
                              NetworkImage('https://picsum.photos/50'),
                        ),
                        SizedBox(width: 8),
                        Text(
                          author,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

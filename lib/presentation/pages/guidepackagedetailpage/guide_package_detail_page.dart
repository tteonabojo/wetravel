import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetravel/presentation/pages/guidepackagedetailpage/widgets/schedule_card.dart';
import 'package:wetravel/presentation/pages/guidepackagedetailpage/widgets/day_selector.dart';
import 'package:wetravel/presentation/pages/guideprofile/guide_profile_page.dart';

class GuidePackageDetailPage extends StatefulWidget {
  final String title;
  final String location;
  final String author;
  final List<String> keywords;

  GuidePackageDetailPage({
    required this.title,
    required this.location,
    required this.author,
    required this.keywords,
  });

  @override
  _GuidePackageDetailPageState createState() => _GuidePackageDetailPageState();
}

class _GuidePackageDetailPageState extends State<GuidePackageDetailPage> {
  String? selectedDay = 'Day 1';
  final Map<String, List<Map<String, String>>> schedule = {
    'Day 1': [
      {
        'time': '오후 1:00',
        'title': '감자호텔에서 체크인 & 점심',
        'location': '호텔 레스토랑',
        'details': '감자요리 밖에 없는 데 다 너무 맛있고 요리가 엄청 다양해요!',
      },
      {
        'time': '오후 2:00',
        'title': '관광지 방문',
        'location': '황거 앞 흑송 2000그루',
        'details': '황거 앞 흑송 2000그루의 잔디밭 광장(국민공원)을 둘러봅니다.',
      },
    ],
    'Day 2': [
      {
        'time': '오전 10:00',
        'title': '박물관 방문',
        'location': '국립 박물관',
        'details': '역사적인 유물과 전시물을 관람합니다.',
      },
    ],
    'Day 3': [
      {
        'time': '오전 10:00',
        'title': '공항으로 간다',
        'location': '제주도 공항',
        'details': '집으로 돌아가기위해 공항으로 돌아가요!.',
      },
    ],
  };

  final Map<String, bool> detailsVisibility = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(), // 뒤로 가기 버튼 고정
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 배경색이 적용되는 컨테이너 시작
            Container(
              color: Colors.white, // 배경색 적용
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    'https://picsum.photos/500',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 260,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GuideProfilePage(author: widget.author),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundImage: NetworkImage('https://picsum.photos/50'),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.author,
                                style: const TextStyle(fontSize: 14, color: Color(0xFF0c0d0e)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.title,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        if (widget.keywords.isNotEmpty)
                          Text(widget.keywords.first, style: TextStyle(color: Color(0xFF6c727a), fontSize: 14)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            SvgPicture.asset('assets/icons/map_pin.svg', width: 24, height: 24),
                            const SizedBox(width: 6),
                            Text(
                              widget.location,
                              style: const TextStyle(fontSize: 16, color: Color(0xFF6c727a)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // 일정 선택 부분 시작
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DaySelector(
                    selectedDay: selectedDay,
                    onDaySelected: (day) => setState(() => selectedDay = day),
                  ),
                  const SizedBox(height: 16),
                  if (selectedDay != null)
                    ...schedule[selectedDay]!.map(
                      (item) => ScheduleCard(
                        time: item['time']!,
                        title: item['title']!,
                        location: item['location']!,
                        details: item['details']!,
                        isDetailsVisible: detailsVisibility['${item['time']}-${item['title']}'] ?? false,
                        onToggleDetails: () {
                          setState(() {
                            detailsVisibility['${item['time']}-${item['title']}'] =
                                !(detailsVisibility['${item['time']}-${item['title']}'] ?? false);
                          });
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey[300]!),
          ),
        ),
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton(
          onPressed: () {
            print("일정 담기");
            if (selectedDay != null) {
              List<Map<String, String>> selectedSchedule = schedule[selectedDay]!;
              print("Selected Schedule for $selectedDay: $selectedSchedule");
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            backgroundColor: const Color(0xFF4876EE), // 메인 컬러
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          child: const Text(
            '일정 담기',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    ));
  }
}

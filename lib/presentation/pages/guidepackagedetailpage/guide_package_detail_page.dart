import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetravel/presentation/pages/guidepackagedetailpage/widgets/schedule_card.dart';
import 'package:wetravel/presentation/pages/guidepackagedetailpage/widgets/day_selector.dart';


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
  };

  final Map<String, bool> detailsVisibility = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                'https://picsum.photos/500',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage('https://picsum.photos/50'),
                          ),
                          const SizedBox(width: 8),
                          Text(widget.author, style: TextStyle(fontSize: 16, color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.title,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      if (widget.keywords.isNotEmpty)
                        Text(widget.keywords.first, style: TextStyle(color: Colors.grey, fontSize: 14)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          SvgPicture.asset('assets/icons/map_pin.svg', width: 24, height: 24),
                          const SizedBox(width: 6),
                        ],
                      ),
                      DaySelector(
                        selectedDay: selectedDay,
                        onDaySelected: (day) => setState(() => selectedDay = day),
                      ),
                    ],
                  ),
                ),
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey[300]!))),
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () => print("일정 담기"),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          ),
          child: const Text('일정 담기', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}

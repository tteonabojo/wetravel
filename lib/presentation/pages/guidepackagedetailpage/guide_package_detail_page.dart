import 'package:flutter/material.dart';

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
  String? selectedDay = 'Day 1'; // 초기 선택된 Day 버튼
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
        'details':
            '황거 앞 흑송 2000그루의 잔디밭 광장(국민공원)을 둘러봅니다. 에도시대 지방영주들의 저택이 있던 곳입니다.',
      },
      {
        'time': '오후 5:00',
        'title': '분위기 좋은 바',
        'location': '라이브 쇼와 바텐더들',
        'details':
            '가격적으로 도 착하고 맛있고 독창적인 와인들과 칵테일들이 존재합니다.',
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
        'time': '오후 3:00',
        'title': '로얄공원 산책',
        'location': '중앙 공원',
        'details': '자연 속에서 여유로운 시간을 보냅니다.',
      },
    ],
  };

  final Map<String, bool> detailsVisibility = {}; // 각 일정에 대해 상세설명 보이기/숨기기 상태를 관리

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
                          Text(
                            widget.author,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (widget.keywords.isNotEmpty)
                        Text(
                          widget.keywords.first,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.red),
                          const SizedBox(width: 8),
                          Text(
                            widget.location,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildDayButton('Day 1'),
                          const SizedBox(width: 8),
                          _buildDayButton('Day 2'),
                          const SizedBox(width: 8),
                          _buildDayButton('Day 3'),
                        ],
                      ),
                    ],
                  ),
                ),
                if (selectedDay != null)
                  ...schedule[selectedDay]!.map((item) {
                    final dayKey = '${item['time']}-${item['title']}';
                    final isDetailsVisible = detailsVisibility[dayKey] ?? false;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Card(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['time']!,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                item['title']!,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 16.0, color: Colors.grey),
                                  const SizedBox(width: 4.0),
                                  Text(
                                    item['location']!,
                                    style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                                  ),
                                ],
                              ),
                              if (item['details']!.isNotEmpty) ...[
                                const SizedBox(height: 8.0),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      detailsVisibility[dayKey] = !isDetailsVisible;
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양쪽 끝에 배치
                                    children: [
                                      Text(
                                        '상세 내용',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Icon(
                                        isDetailsVisible ? Icons.expand_less : Icons.expand_more,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                                if (isDetailsVisible)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      item['details']!,
                                      style: const TextStyle(fontSize: 14.0, color: Colors.black87),
                                    ),
                                  ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey[300]!),
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            print("일정 담기");
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text(
            '일정 담기',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildDayButton(String day) {
    final bool isSelected = selectedDay == day;

    return SizedBox(
      width: 60,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedDay = day;
          });
          print('$day 버튼 눌림');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.grey[800] : Colors.grey,
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        child: Text(
          day,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
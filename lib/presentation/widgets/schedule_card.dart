import 'package:flutter/material.dart';
import 'package:wetravel/domain/entity/schedule.dart';

class ScheduleCard extends StatelessWidget {
  final Schedule schedule;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const ScheduleCard({
    super.key,
    required this.schedule,
    required this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            children: [
              // 왼쪽 이미지 영역
              Container(
                width: 120,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius:
                      BorderRadius.horizontal(left: Radius.circular(12)),
                ),
                child: const Center(
                  child: Text(
                    '위트',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // 오른쪽 컨텐츠 영역
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${schedule.location} 여행', // location으로 제목 표시
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 20),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: onDelete,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${schedule.duration}일', // 기간 표시
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            schedule.location, // 위치 표시
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      if (schedule.isAIRecommended) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                color: Colors.blue,
                                size: 12,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'AI',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

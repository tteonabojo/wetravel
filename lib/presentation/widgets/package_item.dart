import 'package:flutter/material.dart';

class PackageItem extends StatelessWidget {
  final Icon? icon; // 아이콘
  final VoidCallback? onIconTap; // 아이콘 onTap 메서드
  final int? rate; // 순위 표시용
  const PackageItem({super.key, this.icon, this.onIconTap, this.rate});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 312,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  height: 88,
                  width: 88,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://picsum.photos/id/236/200/300',
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        /// TODO: 기본 이미지 필요
                        return Center(child: Text('a'));
                      },
                    ),
                  ),
                ),
                rate != null
                    ? Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          height: 28,
                          width: 28,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: Center(
                            child: Text(
                              '$rate',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '원숭이들이 있는 온천 여행여행여행여행여행여행여행여행여행여행',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // TODO: 기능이 있을 경우 경우 아이콘, function 사용
                      icon != null
                          ? GestureDetector(
                              onTap: onIconTap,
                              child: icon,
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                  Expanded(
                      child: Text(
                    '2박3일 | 혼자 | 도쿄 | 액티비티 | 호텔',
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  )),
                  // TODO: 아이콘 변경 필요
                  Row(
                    children: [
                      Icon(
                        Icons.pin_drop_outlined,
                        size: 18,
                      ),
                      Text('도쿄'),
                    ],
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 6,
                        backgroundImage: NetworkImage(
                            'https://picsum.photos/id/237/200/300'),
                      ),
                      SizedBox(width: 6),
                      Text('나는 이구역짱'),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

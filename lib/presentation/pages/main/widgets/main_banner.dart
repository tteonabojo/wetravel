import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:wetravel/presentation/pages/login/widgets/indicator_circle.dart';
import 'package:wetravel/presentation/pages/login/widgets/indicator_oval.dart';

class MainBanner extends StatefulWidget {
  /// 메인 페이지 배너 영역
  const MainBanner({super.key});

  @override
  State<MainBanner> createState() => _MainBannerState();
}

class _MainBannerState extends State<MainBanner> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<String> imageUrls = [
      'assets/images/login_eiffel.jpg',
      'assets/images/login_balloon.jpg',
      'assets/images/login_beach.jpg',
      'assets/images/login_ocean.jpg',
    ];

    return SizedBox(
      height: 280,
      width: double.infinity,
      child: Column(
        children: [
          CarouselSlider.builder(
            itemCount: imageUrls.length,
            itemBuilder: (context, index, realIndex) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  width: 320,
                  height: double.infinity,
                  imageUrls[index],
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return SizedBox(
                      height: 240,
                      width: 320,
                    );
                  },
                ),
              );
            },
            options: CarouselOptions(
                height: 240,
                autoPlay: true,
                viewportFraction: 0.8,
                autoPlayCurve: Curves.easeInOut,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                }),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imageUrls.asMap().entries.map((entry) {
              int index = entry.key;
              return currentIndex == index
                  ? IndicatorOval()
                  : IndicatorCircle();
            }).toList(),
          )
        ],
      ),
    );
  }
}

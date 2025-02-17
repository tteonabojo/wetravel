import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/presentation/pages/login/widgets/indicator_circle.dart';
import 'package:wetravel/presentation/pages/login/widgets/indicator_oval.dart';
import 'package:wetravel/domain/entity/banner.dart' as banner;

class MainBanner extends StatefulWidget {
  /// 메인 페이지 배너 영역
  final List<banner.Banner> banners;
  const MainBanner({super.key, required this.banners});

  @override
  State<MainBanner> createState() => _MainBannerState();
}

class _MainBannerState extends State<MainBanner> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final banners = widget.banners;
    if (banners.isEmpty) return Center(child: CircularProgressIndicator());

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SizedBox(
        height: 240,
        width: double.infinity,
        child: Column(
          children: [
            CarouselSlider.builder(
              itemCount: banners.length,
              itemBuilder: (context, index, realIndex) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: ClipRRect(
                    borderRadius: AppBorderRadius.small12,
                    child: Image.network(
                      width: 320,
                      height: double.infinity,
                      banners[index].imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        return SizedBox(
                          height: 240,
                          width: 320,
                        );
                      },
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                  height: 200,
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
              children: banners.asMap().entries.map((entry) {
                int index = entry.key;
                return currentIndex == index
                    ? IndicatorOval()
                    : IndicatorCircle();
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}

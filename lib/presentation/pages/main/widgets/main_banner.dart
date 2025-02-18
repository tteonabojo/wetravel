import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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

  /// 배너 url 열기
  Future<void> _launchURL(String? url) async {
    if (url == null || url.isEmpty) return;
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

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
                  child: GestureDetector(
                    onTap: () {
                      _launchURL(banners[index].linkUrl);
                    },
                    child: ClipRRect(
                      borderRadius: AppBorderRadius.small12,
                      child: CachedNetworkImage(
                        width: 320,
                        height: double.infinity,
                        imageUrl: banners[index].imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => SizedBox(
                          height: 240,
                          width: 320,
                          child: Center(
                              child: Icon(Icons.error,
                                  size: 40, color: Colors.red)),
                        ),
                      ),
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
                },
              ),
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

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/core/constants/auth_providers.dart';
import 'package:wetravel/presentation/pages/login/login_page_view_model.dart';
import 'package:wetravel/presentation/pages/login/widgets/indicator_circle.dart';
import 'package:wetravel/presentation/pages/login/widgets/indicator_oval.dart';
import 'package:wetravel/presentation/pages/stack/stack_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final List<String> imageUrls = [
    'assets/images/login_eiffel.jpg',
    'assets/images/login_balloon.jpg',
    'assets/images/login_beach.jpg',
    'assets/images/login_ocean.jpg',
  ];

  int _currentIndex = 0;

  void signInWithProvider({required provider}) async {
    await ref
        .read(loginPageViewModel.notifier)
        .signInWithProvider(provider: provider);
    final user = ref.read(loginPageViewModel);
    if (user?.email != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return StackPage();
      }));
    }
  }

  /// 약관 url
  void _launchURL() async {
    const url =
        'https://weetravel.notion.site/188e73dd935881a8af01f4f12db0d7c9';
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: 103),
                  CarouselSlider.builder(
                    itemCount: imageUrls.length,
                    itemBuilder: (context, index, realIndex) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            width: 280,
                            height: 280,
                            imageUrls[index],
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context, Object error,
                                StackTrace? stackTrace) {
                              return SizedBox(
                                height: 280,
                                width: 280,
                              );
                            },
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                        height: 280,
                        autoPlay: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        }),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: imageUrls.asMap().entries.map((entry) {
                      int index = entry.key;
                      return _currentIndex == index
                          ? IndicatorOval()
                          : IndicatorCircle();
                    }).toList(),
                  ),
                  SizedBox(height: 52),
                  Text(
                    '위트로 간편하게 여행일정을\n등록해보세요',
                    textAlign: TextAlign.center,
                    style: AppTypography.headline3,
                  ),
                  SizedBox(height: 12),
                  Text(
                    '머릿속으로 그리던 일정을 쉽게 만들 수 있어요',
                    style: AppTypography.body2,
                  ),
                ],
              ),
            ),
            Spacer(),
            ElevatedButton(
                onPressed: () {
                  signInWithProvider(provider: AuthProviders.apple);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 52),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AppIcons.apple),
                    Spacer(),
                    Text(
                      'Apple로 로그인',
                      style: AppTypography.buttonLabelMedium
                          .copyWith(color: AppColors.grayScale_250),
                    ),
                    Spacer()
                  ],
                )),
            SizedBox(height: 16),
            ElevatedButton(
                onPressed: () {
                  signInWithProvider(provider: AuthProviders.google);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 52),
                  side: BorderSide(
                    color: AppColors.grayScale_250,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AppIcons.google),
                    Spacer(),
                    Text(
                      'Google로 로그인',
                      style: AppTypography.buttonLabelMedium
                          .copyWith(color: AppColors.grayScale_950),
                    ),
                    Spacer()
                  ],
                )),
            SizedBox(height: 16),
            RichText(
              text: TextSpan(
                style: AppTypography.body3,
                children: [
                  TextSpan(
                    text: '계속 진행하면 ',
                    style: TextStyle(color: AppColors.grayScale_550),
                  ),
                  TextSpan(
                    text: '이용약관/개인정보 처리방침',
                    style: TextStyle(color: AppColors.primary_450),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _launchURL();
                      },
                  ),
                  TextSpan(
                    text: '이 적용됩니다.',
                    style: TextStyle(color: AppColors.grayScale_550),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

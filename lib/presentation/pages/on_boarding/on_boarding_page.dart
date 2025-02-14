import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/on_boarding_images.dart';
import 'package:wetravel/presentation/pages/on_boarding/widgets/on_boarding_screen.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: 0);

    final titles = [
      '위트에 오신걸 환영해요!',
      '쉽고 편하게 여행 패키지를 생성해보세요',
      '위트에선 누구나 가이드가 될 수 있어요',
    ];

    final descriptions = [
      '지금부터 위트에서 여행 여정을 함께해요',
      '위트에서 클릭 몇 번으로 AI나 가이드를 통해\n패키지를 생성할 수 있어요',
      '내가 작성한 여행 패키지로 누군가의 추억을 만들어주세요',
    ];

    final images = [
      OnBoardingImages.first,
      OnBoardingImages.second,
      OnBoardingImages.third,
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        controller: controller,
        itemBuilder: (context, index) {
          return OnBoardingScreen(
            image: images[index],
            title: titles[index],
            description: descriptions[index],
            isLastPage: (index != images.length - 1) ? false : true,
            controller: controller,
          );
        },
      ),
    );
  }
}

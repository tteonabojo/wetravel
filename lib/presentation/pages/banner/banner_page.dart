import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/presentation/pages/banner/widgets/banner_date.dart';
import 'package:wetravel/presentation/pages/banner/widgets/banner_hide.dart';
import 'package:wetravel/presentation/pages/banner/widgets/banner_image.dart';
import 'package:wetravel/presentation/pages/banner/widgets/banner_link.dart';
import 'package:wetravel/presentation/pages/banner/widgets/banner_order.dart';
import 'package:wetravel/presentation/widgets/buttons/standard_button.dart';

class BannerPage extends StatefulWidget {
  const BannerPage({super.key});

  @override
  State<BannerPage> createState() => _BannerPageState();
}

class _BannerPageState extends State<BannerPage> {
  /// 배너 등록
  void submit() {
    print('배너 등록');
  }

  /// 배너 삭제
  void delete() {
    print('배너 삭제');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '배너 등록',
            style: AppTypography.headline4.copyWith(
              color: AppColors.grayScale_950,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () => delete(),
                child: SvgPicture.asset(AppIcons.trash),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BannerImage(),
                    SizedBox(height: 20),
                    BannerLink(),
                    SizedBox(height: 20),
                    BannerDate(),
                    SizedBox(height: 20),
                    BannerOrder(),
                    SizedBox(height: 20),
                    BannerHide(),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 30),
              child: StandardButton.primary(
                sizeType: ButtonSizeType.normal,
                text: '등록하기',
                onPressed: () => submit(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

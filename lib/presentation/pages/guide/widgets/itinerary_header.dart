import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_typography.dart';

class ItineraryHeader extends StatelessWidget {
  const ItineraryHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 156,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        spacing: 8,
        children: [
          SizedBox(
            width: double.infinity,
            child: Row(
              spacing: 8,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/sample_profile.jpg"),
                      fit: BoxFit.cover,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppBorderRadius.small12,
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    child: Text(
                      '나는 이구역짱',
                      style: AppTypography.body2.copyWith(
                        color: AppColors.grayScale_950,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    child: Text(
                      '원숭이들이 있는 온천 여행',
                      style: AppTypography.headline2.copyWith(
                        color: AppColors.grayScale_950,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 28,
                  height: 28,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(),
                        child: Row(
                          children: [
                            Container(
                              child: SvgPicture.asset(
                                AppIcons.pen,
                                color: AppColors.grayScale_550,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    spacing: 8,
                    children: [
                      Text('2박 3일',
                          style: AppTypography.body2.copyWith(
                            color: AppColors.grayScale_550,
                          )),
                      Container(
                        width: 1,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.grayScale_450,
                        ),
                      ),
                      Text(
                        '혼자',
                        style: AppTypography.body2.copyWith(
                          color: AppColors.grayScale_550,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.grayScale_450,
                        ),
                      ),
                      Text(
                        '액티비티',
                        style: AppTypography.body2.copyWith(
                          color: AppColors.grayScale_550,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(),
                        child: Row(
                          children: [
                            Container(
                              child: SvgPicture.asset(
                                AppIcons.mapPin,
                                color: AppColors.grayScale_550,
                                height: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '도쿄',
                        style: TextStyle(
                          color: Color(0xFF69727B),
                          fontSize: 14,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          height: 1.71,
                          letterSpacing: -0.28,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/core/constants/app_typography.dart';

class PackageItem extends StatelessWidget {
  final Icon? icon;
  final VoidCallback? onIconTap;
  final int? rate;
  final String title;
  final String location;

  const PackageItem(
      {super.key,
      this.icon,
      this.onIconTap,
      this.rate,
      required this.title,
      required this.location});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 312,
          height: 120,
          padding: AppSpacing.medium16,
          decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: AppBorderRadius.small12,
              ),
              shadows: AppShadow.generalShadow),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SizedBox(
                  height: 88,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: ShapeDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/cherry_blossom.png"),
                                  fit: BoxFit.cover,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: AppBorderRadius.small8,
                                ),
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
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: double.infinity,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: 24,
                                child: Text(
                                  title,
                                  style: AppTypography.headline5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              SizedBox(
                                width: double.infinity,
                                height: 40,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '2박 3일',
                                            style: AppTypography.body3.copyWith(
                                              color: AppColors.grayScale_650,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            width: 1,
                                            height: 8,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                                color: AppColors.grayScale_550),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '혼자',
                                            style: AppTypography.body3.copyWith(
                                              color: AppColors.grayScale_650,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            width: 1,
                                            height: 8,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                                color: AppColors.grayScale_550),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '액티비티',
                                            style: AppTypography.body3.copyWith(
                                              color: AppColors.grayScale_650,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 12,
                                            height: 12,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(),
                                                  child: SvgPicture.asset(
                                                    AppIcons.mapPin,
                                                    width: 12,
                                                    height: 12,
                                                    color:
                                                        AppColors.grayScale_550,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: SizedBox(
                                              child: Text(
                                                location,
                                                style: AppTypography.body3
                                                    .copyWith(
                                                  color:
                                                      AppColors.grayScale_650,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 2),
                              SizedBox(
                                width: double.infinity,
                                child: Row(
                                  spacing: 4,
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: ShapeDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/sample_profile.jpg"),
                                          fit: BoxFit.cover,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: AppBorderRadius.small12,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        child: Text('나는 이구역짱',
                                            style: AppTypography.body3.copyWith(
                                              color: AppColors.grayScale_750,
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 28,
                height: 28,
                padding: AppSpacing.small4,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AppIcons.trash,
                            width: 20,
                            height: 20,
                            color: AppColors.grayScale_550,
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
      ],
    );
  }
}

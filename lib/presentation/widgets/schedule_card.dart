import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/domain/entity/travel_schedule.dart';

class ScheduleCard extends StatelessWidget {
  final TravelSchedule schedule;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const ScheduleCard({
    super.key,
    required this.schedule,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: AppBorderRadius.medium16,
        color: Colors.white,
        boxShadow: AppShadow.generalShadow,
      ),
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            children: [
              // 왼쪽 이미지 영역
              Container(
                width: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary_450,
                  borderRadius:
                      BorderRadius.horizontal(left: Radius.circular(12)),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 4,
                    children: [
                      SvgPicture.asset(
                        AppIcons.lightFill,
                        color: Colors.white,
                        height: 20,
                      ),
                      Text(
                        'AI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
                              style: AppTypography.headline5
                                  .copyWith(color: AppColors.grayScale_950),
                            ),
                          ),
                          IconButton(
                            icon: SvgPicture.asset(AppIcons.trash, height: 20),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: onDelete,
                          ),
                        ],
                      ),
                      // const SizedBox(height: 4),
                      Text(
                        '${schedule.duration}', // 기간 표시
                        style: AppTypography.body3
                            .copyWith(color: AppColors.grayScale_650),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        spacing: 4,
                        children: [
                          SvgPicture.asset(
                            AppIcons.mapPin,
                            color: AppColors.grayScale_550,
                            height: 12,
                          ),
                          Text(
                            schedule.location, // 위치 표시
                            style: AppTypography.body3
                                .copyWith(color: AppColors.grayScale_550),
                          ),
                        ],
                      ),
                      SizedBox(height: 8)
                      // if (schedule.isAIRecommended) ...[
                      //   const SizedBox(height: 8),
                      //   Container(
                      //     padding: const EdgeInsets.symmetric(
                      //       horizontal: 6,
                      //       vertical: 2,
                      //     ),
                      //     decoration: BoxDecoration(
                      //       color: Colors.blue.withOpacity(0.1),
                      //       borderRadius: BorderRadius.circular(4),
                      //     ),
                      //     child: const Row(
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: [
                      //         Icon(
                      //           Icons.auto_awesome,
                      //           color: Colors.blue,
                      //           size: 12,
                      //         ),
                      //         SizedBox(width: 4),
                      //         Text(
                      //           'AI',
                      //           style: TextStyle(
                      //             color: Colors.blue,
                      //             fontSize: 10,
                      //             fontWeight: FontWeight.bold,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ],
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

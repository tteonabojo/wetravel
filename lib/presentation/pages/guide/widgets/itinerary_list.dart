import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/core/constants/app_typography.dart';

class ItineraryList extends StatefulWidget {
  const ItineraryList({
    super.key,
    required this.onDelete, // 삭제 기능을 위한 콜백
    this.isFirstItem = false, // 첫 번째 항목인지 확인하는 변수
  });

  final Function(int) onDelete; // 삭제 기능 콜백 타입
  final bool isFirstItem; // 첫 번째 항목 여부

  @override
  State<ItineraryList> createState() => _ItineraryListState();
}

class _ItineraryListState extends State<ItineraryList> {
  bool _isExpanded = false; // 텍스트 펼침 여부

  @override
  Widget build(BuildContext context) {
    // 반복되는 글꼴 스타일 상수로 재설정
    final TextStyle bodyStyle =
        AppTypography.body2.copyWith(color: AppColors.grayScale_650);
    final TextStyle headlineStyle =
        AppTypography.headline5.copyWith(color: AppColors.grayScale_950);

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          AnimatedContainer(
            duration: Durations.medium2,
            curve: Curves.easeInOut,
            padding: AppSpacing.medium16,
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: AppBorderRadius.small12),
                shadows: AppShadow.generalShadow),
            child: Column(
              spacing: 8,
              children: [
                // Stack을 사용하여 아이콘 위치 조정
                Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            spacing: 8,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('오전 9:00', style: bodyStyle),
                              Text('공항 도착', style: headlineStyle),
                              Row(
                                spacing: 4,
                                children: [
                                  SvgPicture.asset(
                                    AppIcons.mapPin,
                                    color: AppColors.grayScale_550,
                                    width: 16,
                                  ),
                                  Expanded(
                                      child: Text('나하 국제공항', style: bodyStyle)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (!widget.isFirstItem)
                      Positioned(
                        top: -10,
                        right: -10,
                        child: IconButton(
                          iconSize: 28,
                          onPressed: () {
                            widget.onDelete(0);
                          },
                          icon: SvgPicture.asset(
                            AppIcons.trash,
                            color: AppColors.grayScale_550,
                          ),
                        ),
                      ),
                  ],
                ),
                Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          child: AnimatedCrossFade(
                            firstChild: Text(
                              '황거 앞 흑송 2000그루의 잔디밭 광장(국민공원)을 둘러봅니다.\n에도시대 지방영주들의 저택이 있었던 곳 입니다.\n니쥬바시에서 왼쪽편에 있는 문으로 벗꽃이 많아 사쿠라다몬으로 불리워 진 곳입니다.',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: bodyStyle,
                            ),
                            secondChild: Text(
                              '황거 앞 흑송 2000그루의 잔디밭 광장(국민공원)을 둘러봅니다.\n에도시대 지방영주들의 저택이 있었던 곳 입니다.\n니쥬바시에서 왼쪽편에 있는 문으로 벗꽃이 많아 사쿠라다몬으로 불리워 진 곳입니다.',
                              maxLines: null,
                              overflow: TextOverflow.visible,
                              style: bodyStyle,
                            ),
                            crossFadeState: _isExpanded
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: const Duration(milliseconds: 300),
                            firstCurve: Curves.easeInOut,
                            secondCurve: Curves.easeInOut,
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: -12,
                      right: -10,
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        onPressed: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        icon: SvgPicture.asset(
                          _isExpanded
                              ? AppIcons.chevronUp
                              : AppIcons.chevronDown,
                          color: AppColors.grayScale_550,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

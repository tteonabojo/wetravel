import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/presentation/pages/guide/package_register_page/widgets/widgets/expandable_text.dart';

class ScheduleDetailItem extends StatelessWidget {
  const ScheduleDetailItem({
    required this.time,
    required this.title,
    required this.location,
    required this.content,
    required this.bodyStyle,
    required this.headlineStyle,
    required this.totalScheduleItemCount,
    required this.onDelete,
    required this.onEdit,
    required this.key,
  });

  final String time;
  final String title;
  final String location;
  final String content;
  final TextStyle bodyStyle;
  final TextStyle headlineStyle;
  final int totalScheduleItemCount;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final Key key;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      children: [
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
                      Text(time, style: bodyStyle),
                      Row(
                        spacing: 8,
                        children: [
                          Text(title, style: headlineStyle),
                        ],
                      ),
                      Row(
                        spacing: 4,
                        children: [
                          SvgPicture.asset(
                            AppIcons.mapPin,
                            color: AppColors.grayScale_550,
                            width: 16,
                          ),
                          Expanded(
                            child: Text(location, style: bodyStyle),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 8),
        ExpandableText(content: content, bodyStyle: bodyStyle),
      ],
    );
  }
}

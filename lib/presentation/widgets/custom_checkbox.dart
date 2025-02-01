import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';

class CustomCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          borderRadius: AppBorderRadius.small4,
          border: Border.all(
            color:
                widget.value ? AppColors.primary_450 : AppColors.grayScale_250,
          ),
          color: widget.value ? AppColors.primary_450 : Colors.transparent,
        ),
        child: SvgPicture.asset(
          AppIcons.check,
          color: widget.value ? Colors.white : AppColors.grayScale_250,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wetravel/constants/app_colors.dart';

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
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color:
                widget.value ? AppColors.primary_450 : AppColors.grayScale_250,
          ),
          color: widget.value ? AppColors.primary_450 : Colors.transparent,
        ),
        child: Center(
          child: Icon(
            Icons.check,
            size: 16,
            color: widget.value ? Colors.white : AppColors.grayScale_250,
          ),
        ),
      ),
    );
  }
}

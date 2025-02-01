import 'package:flutter/material.dart';
import 'package:wetravel/presentation/widgets/buttons/chip_button.dart';

class ChipButtonList extends StatelessWidget {
  const ChipButtonList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ChipButton(
            disabledType: DisabledType.disabled150,
            text: 'Day 1',
            isSelected: true,
            onPressed: () {},
          ),
          ChipButton(
            disabledType: DisabledType.disabled150,
            text: 'Day 2',
            isSelected: false,
            onPressed: () {},
          ),
          ChipButton(
            disabledType: DisabledType.disabled150,
            text: 'Day 3',
            isSelected: false,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

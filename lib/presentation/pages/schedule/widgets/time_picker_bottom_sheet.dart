// time_picker_bottom_sheet.dart의 내용은 이전 코드의 _showEditDialog 부분을 분리한 것입니다

import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';

class TimePickerBottomSheet extends StatefulWidget {
  final String initialTime;
  final String initialTitle;
  final String initialLocation;
  final Function(String time, String title, String location) onSave;

  const TimePickerBottomSheet({
    super.key,
    required this.initialTime,
    required this.initialTitle,
    required this.initialLocation,
    required this.onSave,
  });

  @override
  State<TimePickerBottomSheet> createState() => _TimePickerBottomSheetState();
}

class _TimePickerBottomSheetState extends State<TimePickerBottomSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _locationController;
  late FixedExtentScrollController _amPmController;
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;

  String selectedAmPm = '오전';
  String selectedHour = '09';
  String selectedMinute = '00';

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    try {
      final timeParts = widget.initialTime.split(' ');
      if (timeParts.length >= 2) {
        selectedAmPm = timeParts[0];
        final timeValue = timeParts[1];
        if (timeValue.contains(':')) {
          final hourMin = timeValue.split(':');
          selectedHour = hourMin[0].padLeft(2, '0');
          selectedMinute = hourMin[1].padLeft(2, '0');
        }
      }
    } catch (e) {
      debugPrint('시간 파싱 오류: $e');
    }

    _titleController = TextEditingController(text: widget.initialTitle);
    _locationController = TextEditingController(text: widget.initialLocation);
    _amPmController = FixedExtentScrollController(
      initialItem: ['오전', '오후'].indexOf(selectedAmPm),
    );
    _hourController = FixedExtentScrollController(
      initialItem: int.parse(selectedHour) - 1,
    );
    _minuteController = FixedExtentScrollController(
      initialItem: int.parse(selectedMinute) ~/ 5,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _amPmController.dispose();
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  Widget _buildTimePicker({
    required FixedExtentScrollController controller,
    required List<String> items,
    required String selectedItem,
    required Function(int) onChanged,
  }) {
    return Expanded(
      child: SizedBox(
        height: 120,
        child: ListWheelScrollView.useDelegate(
          controller: controller,
          itemExtent: 40,
          physics: const FixedExtentScrollPhysics(),
          onSelectedItemChanged: onChanged,
          childDelegate: ListWheelChildBuilderDelegate(
            builder: (context, index) {
              final isSelected = items[index] == selectedItem;
              return Center(
                child: Text(
                  items[index],
                  style: AppTypography.body1.copyWith(
                    color: isSelected
                        ? AppColors.primary_450
                        : AppColors.grayScale_950,
                  ),
                ),
              );
            },
            childCount: items.length,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '시간',
            style: AppTypography.body1.copyWith(
              color: AppColors.grayScale_950,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 160,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.grayScale_150,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _buildTimePicker(
                  controller: _amPmController,
                  items: const ['오전', '오후'],
                  selectedItem: selectedAmPm,
                  onChanged: (index) {
                    setState(() {
                      selectedAmPm = ['오전', '오후'][index];
                    });
                  },
                ),
                _buildTimePicker(
                  controller: _hourController,
                  items: List.generate(12, (i) => '${i + 1}'.padLeft(2, '0')),
                  selectedItem: selectedHour,
                  onChanged: (index) {
                    setState(() {
                      selectedHour = '${index + 1}'.padLeft(2, '0');
                    });
                  },
                ),
                _buildTimePicker(
                  controller: _minuteController,
                  items: List.generate(12, (i) => '${i * 5}'.padLeft(2, '0')),
                  selectedItem: selectedMinute,
                  onChanged: (index) {
                    setState(() {
                      selectedMinute = '${index * 5}'.padLeft(2, '0');
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: '제목',
              labelStyle: AppTypography.body2.copyWith(
                color: AppColors.grayScale_450,
              ),
              border: const UnderlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _locationController,
            decoration: InputDecoration(
              labelText: '위치',
              labelStyle: AppTypography.body2.copyWith(
                color: AppColors.grayScale_450,
              ),
              border: const UnderlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    '취소',
                    style: AppTypography.body3.copyWith(
                      color: AppColors.grayScale_450,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final time = '$selectedAmPm $selectedHour:$selectedMinute';
                    widget.onSave(
                      time,
                      _titleController.text,
                      _locationController.text,
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary_550,
                  ),
                  child: Text(
                    '저장',
                    style: AppTypography.body3.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

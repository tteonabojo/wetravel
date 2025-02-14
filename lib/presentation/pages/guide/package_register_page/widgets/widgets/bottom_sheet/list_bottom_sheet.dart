import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/presentation/widgets/custom_input_field.dart';
import 'package:wetravel/presentation/widgets/buttons/standard_button.dart';

class ListBottomSheet extends StatefulWidget {
  final String title;
  final String location;
  final String content;
  final String time;
  final Function(String, String, String, String) onSave;

  const ListBottomSheet({
    super.key,
    required this.title,
    required this.location,
    required this.content,
    required this.time,
    required this.onSave,
  });

  @override
  State<ListBottomSheet> createState() => _ListBottomSheetState();
}

class _ListBottomSheetState extends State<ListBottomSheet> {
  late String _title;
  late String _location;
  late String _content;
  late TextEditingController _titleController;
  late TextEditingController _locationController;
  late TextEditingController _contentController;
  late String _selectedAmPm;
  late int _selectedHour;
  late int _selectedMinute;

  late FixedExtentScrollController _amPmController;
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;

  final _formKey = GlobalKey<FormState>();

  final List<String> _amPmList = ['오전', '오후'];
  final List<int> _hourList = List.generate(12, (index) => index + 1);
  final List<int> _minuteList = List.generate(12, (index) => index * 5);

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _location = widget.location;
    _content = widget.content;
    _titleController = TextEditingController(text: _title);
    _locationController = TextEditingController(text: _location);
    _contentController = TextEditingController(text: _content);

    final timeParts = widget.time.split(' ');
    if (timeParts.length == 2) {
      _selectedAmPm = timeParts[0];
      final hourMinute = timeParts[1].split(':');
      _selectedHour = int.tryParse(hourMinute[0]) ?? 9; // 기본시간 9시
      _selectedMinute = int.tryParse(hourMinute[1]) ?? 0;
    } else {
      _selectedAmPm = _amPmList[0];
      _selectedHour = _hourList[8];
      _selectedMinute = _minuteList[0];
    }

    _amPmController = FixedExtentScrollController(
        initialItem: _amPmList.indexOf(_selectedAmPm));
    _hourController = FixedExtentScrollController(
        initialItem: _hourList.contains(_selectedHour)
            ? _hourList.indexOf(_selectedHour)
            : 8);
    _minuteController = FixedExtentScrollController(
        initialItem: _minuteList.contains(_selectedMinute)
            ? _minuteList.indexOf(_selectedMinute)
            : 0);
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;

    const appBarHeight = 56.0;
    final maxBottomSheetHeight =
        screenHeight - (statusBarHeight + appBarHeight);
    final bottomPadding = keyboardHeight > maxBottomSheetHeight
        ? maxBottomSheetHeight
        : keyboardHeight;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            padding: EdgeInsets.only(bottom: bottomPadding),
            constraints: BoxConstraints(
              maxHeight: maxBottomSheetHeight,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppBorderRadius.small12,
              ),
              child: Padding(
                padding: AppSpacing.large20,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      spacing: 20,
                      children: [
                        _buildTimePickerRow(),
                        _buildInputFields(),
                        Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: StandardButton.primary(
                            sizeType: ButtonSizeType.normal,
                            text: '등록',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                String selectedTime =
                                    '$_selectedAmPm $_selectedHour:${_selectedMinute.toString().padLeft(2, '0')}';
                                widget.onSave(
                                  _titleController.text,
                                  _locationController.text,
                                  selectedTime,
                                  _contentController.text,
                                );
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        CustomInputField(
          counterAlignment: Alignment.centerRight,
          controller: _titleController,
          hintText: '제목을 입력하세요',
          keyboardType: TextInputType.text,
          maxLength: 15,
          validator: (value) =>
              value == null || value.trim().isEmpty ? '제목을 입력해주세요.' : null,
          labelText: '제목',
        ),
        CustomInputField(
          counterAlignment: Alignment.centerRight,
          controller: _locationController,
          hintText: '위치를 입력하세요',
          keyboardType: TextInputType.text,
          maxLength: 15,
          validator: (value) =>
              value == null || value.trim().isEmpty ? '위치를 입력해주세요.' : null,
          labelText: '위치',
        ),
        CustomInputField(
          counterAlignment: Alignment.centerRight,
          controller: _contentController,
          hintText: '설명을 입력하세요',
          keyboardType: TextInputType.multiline,
          maxLength: 100,
          validator: (value) =>
              value == null || value.trim().isEmpty ? '설명을 입력해주세요.' : null,
          labelText: '설명',
          maxLines: 5,
        ),
      ],
    );
  }

  Widget _buildTimePickerRow() {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '시간',
          style: AppTypography.headline6.copyWith(
            color: AppColors.grayScale_650,
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: AppColors.grayScale_050,
              borderRadius: AppBorderRadius.small12),
          child: Row(
            children: [
              _buildTimePicker(
                controller: _amPmController,
                items: _amPmList,
                selectedItem: _selectedAmPm,
                onChanged: (index) {
                  setState(() {
                    _selectedAmPm = _amPmList[index];
                  });
                },
              ),
              _buildTimePicker(
                controller: _hourController,
                items: _hourList.map((e) => e.toString()).toList(),
                selectedItem: _selectedHour.toString(),
                onChanged: (index) {
                  setState(() {
                    _selectedHour = _hourList[index];
                  });
                },
              ),
              _buildTimePicker(
                controller: _minuteController,
                items: _minuteList
                    .map((e) => e.toString().padLeft(2, '0'))
                    .toList(),
                selectedItem: _selectedMinute.toString().padLeft(2, '0'),
                onChanged: (index) {
                  setState(() {
                    _selectedMinute = _minuteList[index];
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
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

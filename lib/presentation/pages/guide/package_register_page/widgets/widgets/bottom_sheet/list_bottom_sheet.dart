import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/presentation/widgets/custom_input_field.dart';
import 'package:wetravel/presentation/widgets/buttons/standard_button.dart';

class ListBottomSheet extends StatefulWidget {
  final String title;
  final String location;
  final String content;
  final Function(String, String, String, String) onSave;

  const ListBottomSheet({
    super.key,
    required this.title,
    required this.location,
    required this.content,
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

    _selectedAmPm = _amPmList[0]; // 기본 오전
    _selectedHour = _hourList[0]; // 기본 1시
    _selectedMinute = _minuteList[0]; // 기본 00분

    _amPmController = FixedExtentScrollController(
        initialItem: _amPmList.indexOf(_selectedAmPm));
    _hourController = FixedExtentScrollController(
        initialItem: _hourList.indexOf(_selectedHour));
    _minuteController = FixedExtentScrollController(
        initialItem: _minuteList.indexOf(_selectedMinute));
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppBorderRadius.small12,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 16,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 120,
                        child: ListWheelScrollView.useDelegate(
                          controller: _amPmController,
                          itemExtent: 40,
                          physics: FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              _selectedAmPm = _amPmList[index];
                            });
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context, index) {
                              return Center(
                                child: Text(
                                  _amPmList[index],
                                  style: TextStyle(
                                    color: _selectedAmPm == _amPmList[index]
                                        ? AppColors.primary_450
                                        : AppColors.grayScale_950,
                                  ),
                                ),
                              );
                            },
                            childCount: _amPmList.length,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 120,
                        child: ListWheelScrollView.useDelegate(
                          controller: _hourController,
                          itemExtent: 40,
                          physics: FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              _selectedHour = _hourList[index];
                            });
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context, index) {
                              return Center(
                                child: Text(
                                  _hourList[index].toString(),
                                  style: TextStyle(
                                    color: _selectedHour == _hourList[index]
                                        ? AppColors.primary_450
                                        : AppColors.grayScale_950,
                                  ),
                                ),
                              );
                            },
                            childCount: _hourList.length,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 120,
                        child: ListWheelScrollView.useDelegate(
                          controller: _minuteController,
                          itemExtent: 40,
                          physics: FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              _selectedMinute = _minuteList[index];
                            });
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context, index) {
                              return Center(
                                child: Text(
                                  _minuteList[index].toString().padLeft(2, '0'),
                                  style: TextStyle(
                                    color: _selectedMinute == _minuteList[index]
                                        ? AppColors.primary_450
                                        : AppColors.grayScale_950,
                                  ),
                                ),
                              );
                            },
                            childCount: _minuteList.length,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                CustomInputField(
                  controller: _titleController,
                  hintText: '제목을 입력하세요',
                  keyboardType: TextInputType.text,
                  maxLength: 15,
                  labelText: '제목',
                ),
                CustomInputField(
                  controller: _locationController,
                  hintText: '위치를 입력하세요',
                  keyboardType: TextInputType.text,
                  maxLength: 15,
                  labelText: '위치',
                ),
                CustomInputField(
                  controller: _contentController,
                  hintText: '설명을 입력하세요',
                  keyboardType: TextInputType.multiline,
                  maxLength: 100,
                  labelText: '설명',
                  maxLines: 5,
                ),
                StandardButton.primary(
                  sizeType: ButtonSizeType.normal,
                  text: '등록',
                  onPressed: () {
                    String selectedTime =
                        '$_selectedAmPm $_selectedHour:${_selectedMinute.toString().padLeft(2, '0')}';
                    widget.onSave(
                      _titleController.text,
                      _locationController.text,
                      selectedTime,
                      _contentController.text,
                    );
                    Navigator.pop(context);
                    print('일정표 수정완료!');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/presentation/pages/guide/package_register_page/widgets/widgets/bottom_sheet/widgets/keyword_selection.dart';
import 'package:wetravel/presentation/widgets/buttons/standard_button.dart';
import 'package:wetravel/presentation/widgets/custom_input_field.dart';

class HeaderBottomSheet extends StatefulWidget {
  final String title;
  final String location;
  final List<String?> selectedKeywords;
  final Function(String, List<String?>, String) onSave;

  const HeaderBottomSheet({
    super.key,
    required this.title,
    required this.location,
    required this.selectedKeywords,
    required this.onSave,
  });

  @override
  State<HeaderBottomSheet> createState() => _HeaderBottomSheetState();
}

class _HeaderBottomSheetState extends State<HeaderBottomSheet> {
  late String _title;
  late String _location;
  late List<String?> _selectedKeywords;
  late TextEditingController _titleController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _location = widget.location;
    _selectedKeywords = List.from(widget.selectedKeywords);
    _titleController = TextEditingController(text: _title);
    _locationController = TextEditingController(text: _location);
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
                CustomInputField(
                  controller: _titleController,
                  hintText: '제목을 입력하세요',
                  keyboardType: TextInputType.text,
                  maxLength: 15,
                  labelText: '제목',
                ),
                KeywordSelection(
                  onKeywordsSelected: (keywords) {
                    setState(() {
                      _selectedKeywords = keywords;
                    });
                  },
                  initialSelectedKeywords: _selectedKeywords,
                ),
                const SizedBox(height: 12),
                CustomInputField(
                  controller: _locationController,
                  hintText: '위치를 입력하세요',
                  keyboardType: TextInputType.text,
                  maxLength: 15,
                  labelText: '위치',
                ),
                StandardButton.primary(
                  sizeType: ButtonSizeType.normal,
                  text: '등록',
                  onPressed: () {
                    widget.onSave(
                      _titleController.text,
                      _selectedKeywords,
                      _locationController.text,
                    );
                    Navigator.pop(context);
                    print('일정표 헤더 수정완료!');
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

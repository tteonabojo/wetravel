import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
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

  final _formKey = GlobalKey<FormState>();
  double _keyboardHeight = 0;

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
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  String? _validateField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName 입력해주세요.';
    }
    return null;
  }

  Widget _buildTitleInputField() {
    return CustomInputField(
      counterAlignment: Alignment.centerRight,
      controller: _titleController,
      hintText: '제목을 입력하세요',
      keyboardType: TextInputType.text,
      maxLength: 30,
      validator: (value) => _validateField(value, '제목을'),
      labelText: '제목',
    );
  }

  Widget _buildLocationInputField() {
    return CustomInputField(
      counterAlignment: Alignment.centerRight,
      controller: _locationController,
      hintText: '위치를 입력하세요',
      keyboardType: TextInputType.text,
      maxLength: 30,
      validator: (value) => _validateField(value, '위치를'),
      labelText: '위치',
    );
  }

  Widget _buildKeywordSelection() {
    return KeywordSelection(
      onKeywordsSelected: (keywords) {
        setState(() {
          _selectedKeywords = keywords;
        });
      },
      initialSelectedKeywords: _selectedKeywords,
    );
  }

  @override
  Widget build(BuildContext context) {
    _keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: AnimatedPadding(
          padding: EdgeInsets.only(bottom: _keyboardHeight),
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            ),
            child: Padding(
              padding: AppSpacing.medium16,
              child: Form(
                key: _formKey,
                child: Column(
                  spacing: 8,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTitleInputField(),
                    _buildKeywordSelection(),
                    const SizedBox(height: 24),
                    _buildLocationInputField(),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: StandardButton.primary(
                        sizeType: ButtonSizeType.normal,
                        text: '등록',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            widget.onSave(
                              _titleController.text.trim(),
                              _selectedKeywords,
                              _locationController.text.trim(),
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
      ),
    );
  }
}

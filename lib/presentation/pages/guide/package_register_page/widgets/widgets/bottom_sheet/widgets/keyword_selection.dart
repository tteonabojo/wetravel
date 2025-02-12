import 'package:flutter/cupertino.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/presentation/widgets/buttons/chip_button.dart';

class KeywordSelection extends StatefulWidget {
  final Function(List<String?>) onKeywordsSelected;
  final List<String?> initialSelectedKeywords;

  const KeywordSelection({
    super.key,
    required this.onKeywordsSelected,
    required this.initialSelectedKeywords,
  });

  @override
  State<KeywordSelection> createState() => _KeywordSelectionState();
}

class _KeywordSelectionState extends State<KeywordSelection> {
  static const List<List<String>> _keywordLists = [
    ['당일치기', '1박 2일', '2박 3일', '3박 4일', '4박 5일', '5박 6일', '6박 7일 이상'],
    ['혼자', '연인과', '친구와', '반려동물', '가족과'],
    ['액티비티', '휴양', '유명 관광지', '힐링', '자연', '먹방', '문화/예술/역사'],
  ];

  late List<String?> _selectedKeywords;

  @override
  void initState() {
    super.initState();
    _selectedKeywords = List.generate(
        3,
        (i) => i < widget.initialSelectedKeywords.length
            ? widget.initialSelectedKeywords[i]
            : null);
  }

  void _showCupertinoPicker(int index) {
    final initialIndex = _keywordLists[index]
        .indexOf(_selectedKeywords[index] ?? _keywordLists[index][0]);

    int selectedIndex = initialIndex;

    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text('키워드 선택', style: AppTypography.headline6),
        actions: [
          SizedBox(
            height: 200,
            child: CupertinoPicker(
              backgroundColor: AppColors.grayScale_050,
              scrollController:
                  FixedExtentScrollController(initialItem: initialIndex),
              itemExtent: 40,
              onSelectedItemChanged: (pickerIndex) {
                selectedIndex = pickerIndex;
              },
              children: _keywordLists[index]
                  .map((keyword) => Center(
                        child: Text(
                          keyword,
                          style: AppTypography.body1
                              .copyWith(color: AppColors.grayScale_950),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            setState(() {
              _selectedKeywords[index] = _keywordLists[index][selectedIndex];
            });
            widget.onKeywordsSelected(_selectedKeywords);
            Navigator.pop(context);
          },
          child: const Text('확인'),
        ),
      ),
    );
  }

  Widget _buildKeywordChips() {
    return Row(
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChipButton(
            text: _selectedKeywords[index] ?? '키워드 ${index + 1}',
            isSelected: _selectedKeywords[index] != null,
            onPressed: () => _showCupertinoPicker(index),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '키워드 선택',
          style:
              AppTypography.headline6.copyWith(color: AppColors.grayScale_650),
        ),
        _buildKeywordChips(),
      ],
    );
  }
}

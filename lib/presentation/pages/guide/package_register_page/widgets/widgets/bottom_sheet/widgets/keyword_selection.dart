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
  final List<List<String>> _keywordLists = [
    ['당일치기', '1박 2일', '2박 3일', '3박 4일', '4박 5일', '5박 6일', '6박 7일 이상'],
    ['혼자', '연인과', '친구와', '반려동물', '가족과'],
    ['액티비티', '휴양', '유명 관광지', '힐링', '자연', '먹방', '문화/예술/역사'],
  ];

  late List<String?> _selectedKeywords;

  @override
  void initState() {
    super.initState();
    _selectedKeywords = List<String?>.filled(3, null);
    for (int i = 0; i < widget.initialSelectedKeywords.length && i < 3; i++) {
      _selectedKeywords[i] = widget.initialSelectedKeywords[i];
    }
  }

  void _showCupertinoPicker(int index) {
    final initialIndex = _keywordLists[index]
        .indexOf(_selectedKeywords[index] ?? _keywordLists[index][0]);
    final scrollController =
        FixedExtentScrollController(initialItem: initialIndex);

    setState(() {
      _selectedKeywords[index] = _keywordLists[index][initialIndex];
    });
    widget.onKeywordsSelected(_selectedKeywords);

    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text('키워드 선택', style: AppTypography.headline6),
          actions: [
            SizedBox(
              height: 200,
              child: CupertinoPicker(
                scrollController: scrollController,
                itemExtent: 40,
                onSelectedItemChanged: (pickerIndex) {
                  setState(() {
                    _selectedKeywords[index] =
                        _keywordLists[index][pickerIndex];
                  });
                  widget.onKeywordsSelected(_selectedKeywords);
                },
                children: _keywordLists[index].map((keyword) {
                  return Center(
                    child: Text(
                      keyword,
                      style: AppTypography.body1
                          .copyWith(color: AppColors.grayScale_950),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '키워드 선택',
          style:
              AppTypography.headline6.copyWith(color: AppColors.grayScale_650),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(3, (index) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChipButton(
                text: _selectedKeywords[index] ?? '키워드 ${index + 1}',
                isSelected: _selectedKeywords[index] != null,
                onPressed: () => _showCupertinoPicker(index),
              ),
            );
          }),
        )
      ],
    );
  }
}

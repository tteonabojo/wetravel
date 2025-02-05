import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/domain/entity/user.dart';
import 'package:wetravel/presentation/provider/user_provider.dart';

class PackageDetailHeader extends ConsumerStatefulWidget {
  final String title;
  final List<String> keywordList;
  final String location;
  final Function(String, List<String>, String) onUpdate;

  const PackageDetailHeader({
    super.key,
    required this.title,
    required this.keywordList,
    required this.location,
    required this.onUpdate,
  });

  @override
  _PackageHeaderState createState() => _PackageHeaderState();
}

class _PackageHeaderState extends ConsumerState<PackageDetailHeader> {
  late String _title;
  late String _location;
  List<String?> _selectedKeywords = [null, null, null];

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _location = widget.location;
    if (widget.keywordList.isNotEmpty) {
      _selectedKeywords = List.from(widget.keywordList.map((e) => e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final userRepository = ref.watch(userRepositoryProvider);

    return FutureBuilder<User>(
      future: userRepository.fetchUser(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('에러 발생: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final user = snapshot.data!;
          return Container(
            width: double.infinity,
            height: 156,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              spacing: 8,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    spacing: 8,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: ShapeDecoration(
                          image: DecorationImage(
                            image: NetworkImage(user.imageUrl ??
                                "assets/images/sample_profile.jpg"),
                            fit: BoxFit.cover,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppBorderRadius.small12,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          child: Text(
                            user.name ?? '사용자 이름',
                            style: AppTypography.body2.copyWith(
                              color: AppColors.grayScale_950,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          child: Text(
                            _title,
                            style: AppTypography.headline2.copyWith(
                              color: AppColors.grayScale_950,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: _selectedKeywords
                              .asMap()
                              .entries
                              .map((entry) {
                                final index = entry.key;
                                final keyword =
                                    entry.value ?? '키워드 ${index + 1}';
                                return [
                                  Text(
                                    keyword,
                                    style: AppTypography.body2.copyWith(
                                      color: AppColors.grayScale_550,
                                    ),
                                  ),
                                  if (index < _selectedKeywords.length - 1)
                                    SizedBox(
                                      height: 12,
                                      child: VerticalDivider(
                                        color: AppColors.grayScale_450,
                                        thickness: 1,
                                        width: 16,
                                      ),
                                    ),
                                ];
                              })
                              .expand((widget) => widget)
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(),
                              child: Row(
                                children: [
                                  Container(
                                    child: SvgPicture.asset(
                                      AppIcons.mapPin,
                                      color: AppColors.grayScale_550,
                                      height: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(_location,
                                style: AppTypography.body2.copyWith(
                                  color: AppColors.grayScale_550,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(child: Text('사용자 정보가 없습니다.'));
        }
      },
    );
  }
}

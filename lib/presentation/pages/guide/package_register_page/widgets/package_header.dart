import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/presentation/pages/guide/package_register_page/widgets/widgets/bottom_sheet/header_bottom_sheet.dart';
import 'package:wetravel/domain/entity/user.dart';
import 'package:wetravel/presentation/provider/user_provider.dart';

class PackageHeader extends ConsumerStatefulWidget {
  final String title;
  final List<String> keywordList;
  final String location;
  final Function(String, List<String>, String) onUpdate;
  final GlobalKey<PackageHeaderState> key;

  const PackageHeader({
    required this.title,
    required this.keywordList,
    required this.location,
    required this.onUpdate,
    required this.key,
  });

  @override
  PackageHeaderState createState() => PackageHeaderState();
}

class PackageHeaderState extends ConsumerState<PackageHeader> {
  late String _title;
  late String _location;
  late List<String?> _selectedKeywords;

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _location = widget.location;
    _selectedKeywords = List.from(widget.keywordList.isNotEmpty
        ? widget.keywordList
        : [null, null, null]);
  }

  void showEditBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return HeaderBottomSheet(
          title: _title,
          location: _location,
          selectedKeywords: _selectedKeywords,
          onSave: (newTitle, newKeywords, newLocation) {
            setState(() {
              _title = newTitle;
              _location = newLocation;
              _selectedKeywords = List.from(newKeywords);
            });
            widget.onUpdate(
              _title,
              _selectedKeywords.where((e) => e != null).cast<String>().toList(),
              _location,
            );
          },
        );
      },
    );
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
          return GestureDetector(
            onTap: showEditBottomSheet,
            child: Container(
              padding: AppSpacing.medium16,
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserInfo(user),
                  SizedBox(height: 8),
                  _buildKeywordRow(),
                  SizedBox(height: 4),
                  _buildLocationRow(),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: Text('사용자 정보가 없습니다.'));
        }
      },
    );
  }

  Widget _buildUserInfo(User user) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundImage: user.imageUrl?.isNotEmpty ?? false
              ? NetworkImage(user.imageUrl!)
              : const AssetImage("assets/images/sample_profile.jpg"),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            user.name?.trim().isNotEmpty ?? false ? user.name! : '닉네임 없음',
            style: AppTypography.body2.copyWith(color: AppColors.grayScale_950),
          ),
        ),
      ],
    );
  }

  Widget _buildKeywordRow() {
    return Row(
      children: [
        ..._selectedKeywords.asMap().entries.map((entry) {
          final index = entry.key;
          final keyword = entry.value ?? '키워드 ${index + 1}';
          return Row(
            children: [
              Text(
                keyword,
                style: AppTypography.body2
                    .copyWith(color: AppColors.grayScale_550),
              ),
              if (index < _selectedKeywords.length - 1)
                Container(
                  height: 12,
                  width: 1,
                  color: AppColors.grayScale_450,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildLocationRow() {
    return Row(
      children: [
        SvgPicture.asset(
          AppIcons.mapPin,
          color: AppColors.grayScale_550,
          height: 16,
        ),
        const SizedBox(width: 4),
        Text(
          _location.isNotEmpty ? _location : '위치',
          style: AppTypography.body2.copyWith(color: AppColors.grayScale_550),
        ),
        Spacer(),
        SvgPicture.asset(
          AppIcons.pen,
          color: AppColors.grayScale_450,
          width: 20,
        ),
      ],
    );
  }
}

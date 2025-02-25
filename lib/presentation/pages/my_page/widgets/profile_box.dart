import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/presentation/pages/my_page_correction/mypage_correction.dart';

class ProfileBox extends StatelessWidget {
  final Map<String, dynamic>? userData;
  ProfileBox({required this.userData});

  @override
  Widget build(BuildContext context) {
    if (userData == null) return Text('사용자 데이터를 불러올 수 없습니다.');
    final profile = ProfileData.fromMap(userData!);

    return Container(
      height: 89,
      padding: const EdgeInsets.symmetric(vertical: 16.5, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppBorderRadius.small12,
        boxShadow: AppShadow.generalShadow,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage:
                profile.hasValidImage ? NetworkImage(profile.imageUrl) : null,
            child: profile.hasValidImage
                ? null
                : SvgPicture.asset(AppIcons.userRound),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                spacing: 8,
                children: [
                  Text(profile.name, style: AppTypography.headline5),
                  if (profile.isAdmin)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary_450,
                        borderRadius: AppBorderRadius.small4,
                      ),
                      child: Text('관리자',
                          style: AppTypography.buttonLabelXSmall
                              .copyWith(color: Colors.white)),
                    ),
                ],
              ),
              SizedBox(height: 4),
              Text(profile.shortEmail,
                  style: AppTypography.body3
                      .copyWith(color: AppColors.grayScale_450)),
            ],
          ),
          Spacer(),
          IconButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => MyPageCorrection())),
            icon: SvgPicture.asset(AppIcons.pen, width: 20, height: 20),
          ),
        ],
      ),
    );
  }
}

class ProfileData {
  final String name, email, imageUrl;
  final bool isAdmin;
  ProfileData({
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.isAdmin,
  });

  factory ProfileData.fromMap(Map<String, dynamic> map) {
    final name = map['name']?.isNotEmpty == true
        ? map['name']
        : '닉네임없음';
    return ProfileData(
      name: name,
      email: map['email'] ?? '이메일 없음',
      imageUrl: map['imageUrl'] ?? '',
      isAdmin: map['isAdmin'] ?? false,
    );
  }

  bool get hasValidImage => imageUrl.startsWith('http');
  String get shortEmail =>
      email.length > 25 ? '${email.substring(0, 20)}...' : email;
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/domain/entity/user.dart';
import 'package:wetravel/presentation/provider/user_provider.dart';

class GuideInfo extends ConsumerWidget {
  const GuideInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchUserUsecase = ref.watch(fetchUserUsecaseProvider);

    return FutureBuilder<User?>(
      future: fetchUserUsecase.execute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(height: 100, color: Colors.white);
        } else if (snapshot.hasError) {
          return const Center(child: Text('유저 정보를 불러올 수 없습니다.'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('유저 정보가 없습니다.'));
        }
        final user = snapshot.data!;
        final imageUrl = user.imageUrl ?? 'assets/images/sample_profile.jpg';
        final nickname = user.name ?? '이름 없음';

        return Container(
          width: double.infinity,
          height: 100,
          padding: AppSpacing.medium16,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: AppBorderRadius.small12,
            ),
            shadows: AppShadow.generalShadow,
          ),
          child: Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: imageUrl.startsWith('http')
                        ? NetworkImage(imageUrl) as ImageProvider
                        : AssetImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    nickname,
                    style: AppTypography.headline6,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '가이드님 환영합니다',
                    style: AppTypography.body2,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

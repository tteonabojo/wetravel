import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'package:wetravel/presentation/pages/mypagecorrection/mypage_correction.dart';
import 'package:wetravel/presentation/provider/user_provider.dart';

class ProfileBox extends ConsumerWidget {
  const ProfileBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userStreamProvider);

    return userAsync.when(
      data: (userData) {
        if (userData == null) {
          return const Text('사용자 데이터를 불러올 수 없습니다.');
        }

        final name = userData['name'] ?? '이름 없음';
        final email = userData['email'] ?? '이메일 없음';
        final imageUrl = userData['imageUrl'];
        final validUrl = '$imageUrl'.startsWith('http');

        return Container(
          height: 89,
          padding: const EdgeInsets.symmetric(vertical: 16.5, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: AppShadow.generalShadow,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: validUrl ? NetworkImage(imageUrl) : null,
                child: validUrl ? null : SvgPicture.asset(AppIcons.userRound),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    (email.length > 25) ? '${email.substring(0, 20)}...' : email,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyPageCorrection()),
                  );
                },
                icon: SvgPicture.asset(
                  AppIcons.pen,
                  width: 24,
                  height: 24,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Text('오류 발생: $err'),
    );
  }
}
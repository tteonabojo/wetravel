import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/core/constants/firestore_constants.dart';
import 'package:wetravel/domain/entity/package.dart';
import 'package:wetravel/domain/entity/schedule.dart';
import 'package:wetravel/domain/usecase/package/get_package_usecase.dart';
import 'package:wetravel/domain/usecase/schedule/get_schedules_usecase.dart';
import 'package:wetravel/presentation/pages/guide_package_detail_page/widgets/detail_schedule_list.dart';
import 'package:wetravel/presentation/pages/guide_package_detail_page/widgets/package_detail_header.dart';
import 'package:wetravel/presentation/pages/guide_package_detail_page/widgets/package_detail_image.dart';
import 'package:wetravel/presentation/pages/guide_package_detail_page/widgets/detail_day_chip_button.dart';
import 'package:wetravel/presentation/provider/package_provider.dart';
import 'package:wetravel/presentation/provider/schedule_provider.dart';
import 'package:wetravel/presentation/widgets/buttons/standard_button.dart';

class PackageDetailPage extends ConsumerStatefulWidget {
  final String packageId;

  const PackageDetailPage({super.key, required this.packageId});

  @override
  _PackageDetailPageState createState() => _PackageDetailPageState();
}

class _PackageDetailPageState extends ConsumerState<PackageDetailPage> {
  int selectedDay = 1;
  Package? package;
  Map<int, List<Schedule>> scheduleMap = {};
  bool isAdmin = false;

  late final GetPackageUseCase getPackageUseCase;
  late final GetSchedulesUsecase getSchedulesUseCase;

  @override
  void initState() {
    super.initState();
    getPackageUseCase = ref.read(getPackageUseCaseProvider);
    getSchedulesUseCase = ref.read(getSchedulesUseCaseProvider);
    _initializePage();
  }

  Future<void> _initializePage() async {
    await _checkAdminStatus();
    await _loadData();
  }

  Future<void> _checkAdminStatus() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;
      final userRef = FirebaseFirestore.instance
          .collection(FirestoreConstants().usersCollection)
          .doc(currentUser.uid);
      final userSnapshot = await userRef.get();
      if (userSnapshot.exists) {
        final data = userSnapshot.data();
        setState(() {
          isAdmin = data?['isAdmin'] ?? false;
        });
      }
    } catch (e) {
      print('Admin check failed: $e');
    }
  }

  Future<void> _loadData() async {
    try {
      final fetchedPackage = await getPackageUseCase.execute(widget.packageId);
      final scheduleIdList = fetchedPackage?.scheduleIdList ?? [];
      if (scheduleIdList.isEmpty) throw Exception('No schedules available.');
      final schedules = await getSchedulesUseCase.execute(scheduleIdList);

      final tempScheduleMap = <int, List<Schedule>>{};
      for (var schedule in schedules) {
        tempScheduleMap.putIfAbsent(schedule.day, () => []).add(schedule);
      }

      await _incrementViewCount(fetchedPackage?.id ?? '');
      await _updateRecentPackages(fetchedPackage?.id ?? '');

      setState(() {
        package = fetchedPackage;
        scheduleMap = tempScheduleMap;
      });
    } catch (e, stacktrace) {
      print('Error loading data: $e');
      print('Stacktrace: $stacktrace');
    }
  }

  Future<void> _incrementViewCount(String packageId) async {
    try {
      final packageRef = FirebaseFirestore.instance
          .collection(FirestoreConstants().packagesCollection)
          .doc(packageId);
      final packageSnapshot = await packageRef.get();
      if (packageSnapshot.exists) {
        final currentViewCount = packageSnapshot.data()?['viewCount'] ?? 0;
        await packageRef.update({'viewCount': currentViewCount + 1});
      }
    } catch (e) {
      print('View count update failed: $e');
    }
  }

  Future<void> _updateRecentPackages(String packageId) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;
      final userRef = FirebaseFirestore.instance
          .collection(FirestoreConstants().usersCollection)
          .doc(currentUser.uid);
      final userSnapshot = await userRef.get();
      if (userSnapshot.exists) {
        final data = userSnapshot.data();
        List<String> recentPackages =
            List<String>.from(data?['recentPackages'] ?? []);
        recentPackages.remove(packageId);
        recentPackages.insert(0, packageId);
        if (recentPackages.length > 3) recentPackages.removeLast();
        await userRef.update({'recentPackages': recentPackages});
      }
    } catch (e) {
      print('Failed to update recent packages: $e');
    }
  }

  Future<void> _addToScrapList() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;
      final userRef = FirebaseFirestore.instance
          .collection(FirestoreConstants().usersCollection)
          .doc(currentUser.uid);
      final userSnapshot = await userRef.get();
      if (userSnapshot.exists) {
        final data = userSnapshot.data();
        List<String> scrapIdList =
            List<String>.from(data?['scrapIdList'] ?? []);
        if (scrapIdList.contains(package?.id)) {
          _showSnackBar('이미 담긴 패키지입니다.');
        } else {
          scrapIdList.add(package?.id ?? '');
          await userRef.update({'scrapIdList': scrapIdList});
          _showSnackBar('패키지가 담겼습니다.');
        }
      }
    } catch (e) {
      print('Failed to add to scrap list: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (package == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: CircularProgressIndicator(color: AppColors.primary_450)),
      );
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    final isOwner = currentUser?.uid == package!.userId;

    return Scaffold(
      appBar: AppBar(
        title: Text(package?.title ?? '패키지 상세',
            style: AppTypography.headline4
                .copyWith(color: AppColors.grayScale_950)),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PackageDetailImage(
                    imagePath: package?.imageUrl ?? '',
                    onImageSelected: (_) {}),
                PackageDetailHeader(
                  title: package?.title ?? '제목 없음',
                  keywordList: package?.keywordList ?? [],
                  location: package?.location ?? '위치 정보 없음',
                  onUpdate: (newTitle, newKeywordList, newLocation) {},
                  userId: package!.userId,
                ),
                divider(1),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16),
                  child: DetailDayChipButton(
                    onPressed: () {},
                    currentDayCount: scheduleMap.keys.length,
                    onSelectDay: (day) => setState(() => selectedDay = day),
                    selectedDay: selectedDay,
                  ),
                ),
                Padding(
                  padding: AppSpacing.medium16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var schedule in scheduleMap[selectedDay] ?? [])
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: DetailScheduleList(
                            schedules: [
                              {
                                'time': '${schedule.time ?? ''}',
                                'title': '${schedule.title ?? ''}',
                                'location': '${schedule.location ?? ''}',
                                'content': '${schedule.content ?? ''}',
                                'imageUrl': '${schedule.imageUrl ?? ''}',
                              }
                            ],
                            totalScheduleCount:
                                scheduleMap[selectedDay]?.length ?? 0,
                            dayIndex: selectedDay - 1,
                            onSave: (time, title, location, content, index) {},
                            onDelete: (dayIndex, scheduleIndex) {},
                            key: ValueKey(selectedDay),
                          ),
                        ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!isOwner && !isAdmin && package!.isHidden)
            Positioned.fill(
              child: Stack(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(color: Colors.black.withOpacity(0.5)),
                  ),
                  Center(
                    child: Text('비공개 패키지 입니다',
                        style: AppTypography.headline4.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: AppSpacing.medium16.copyWith(bottom: 30),
        child: StandardButton.primary(
            onPressed: _addToScrapList,
            sizeType: ButtonSizeType.normal,
            text: '패키지 담기'),
      ),
    );
  }

  Container divider(double height) {
    return Container(
        width: double.infinity,
        height: height,
        decoration: const BoxDecoration(color: AppColors.grayScale_150));
  }
}

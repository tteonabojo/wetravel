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
import 'package:wetravel/domain/usecase/get_package_usecase.dart';
import 'package:wetravel/domain/usecase/get_schedules_usecase.dart';
import 'package:wetravel/presentation/pages/guide_package_detail_page/widgets/detail_schedule_list.dart';
import 'package:wetravel/presentation/pages/guide_package_detail_page/widgets/package_detail_header.dart';
import 'package:wetravel/presentation/pages/guide_package_detail_page/widgets/package_detail_image.dart';
import 'package:wetravel/presentation/pages/guide_package_detail_page/widgets/detail_day_chip_button.dart';
import 'package:wetravel/presentation/widgets/buttons/standard_button.dart';

class PackageDetailPage extends ConsumerStatefulWidget {
  final String packageId;
  final GetPackageUseCase getPackageUseCase;
  final GetSchedulesUsecase getSchedulesUseCase;

  const PackageDetailPage({
    super.key,
    required this.packageId,
    required this.getPackageUseCase,
    required this.getSchedulesUseCase,
  });

  @override
  _PackageDetailPageState createState() => _PackageDetailPageState();
}

class _PackageDetailPageState extends ConsumerState<PackageDetailPage> {
  int selectedDay = 1;
  Package? package;
  Map<int, List<Schedule>> scheduleMap = {};
  final FirestoreConstants firestoreConstants = FirestoreConstants();

  late final GetPackageUseCase getPackageUseCase;
  late final GetSchedulesUsecase getSchedulesUseCase;

  @override
  void initState() {
    super.initState();
    getPackageUseCase = widget.getPackageUseCase;
    getSchedulesUseCase = widget.getSchedulesUseCase;
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final fetchedPackage = await getPackageUseCase.execute(widget.packageId);

      final scheduleIdList = fetchedPackage!.scheduleIdList;
      if (scheduleIdList == null || scheduleIdList.isEmpty) {
        throw Exception('패키지에 연결된 스케줄이 없습니다.');
      }

      final schedules = await getSchedulesUseCase.execute(scheduleIdList);

      final tempScheduleMap = <int, List<Schedule>>{};

      for (var schedule in schedules) {
        tempScheduleMap.putIfAbsent(schedule.day, () => []).add(schedule);
      }

      await _incrementViewCount(fetchedPackage.id);
      await _updateRecentPackages(fetchedPackage.id);

      setState(() {
        package = fetchedPackage;
        scheduleMap = tempScheduleMap;
      });
    } catch (e, stacktrace) {
      print('Error loading data: $e');
      print('Stacktrace: $stacktrace');
    }
  }

  Future<void> _updateRecentPackages(String packageId) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print('사용자가 로그인되어 있지 않습니다.');
        return;
      }

      final userRef = FirebaseFirestore.instance
          .collection(firestoreConstants.usersCollection) // 수정된 부분
          .doc(currentUser.uid);

      final userSnapshot = await userRef.get();
      if (userSnapshot.exists) {
        final data = userSnapshot.data();
        List<String> recentPackages =
            List<String>.from(data?['recentPackages'] ?? []);

        recentPackages.remove(packageId);

        recentPackages.insert(0, packageId);

        if (recentPackages.length > 3) {
          recentPackages.removeLast();
        }

        await userRef.update({'recentPackages': recentPackages});
      } else {
        print('사용자 데이터를 찾을 수 없습니다.');
      }
    } catch (e) {
      print('오류 발생: $e');
    }
  }

  Future<void> _incrementViewCount(String packageId) async {
    try {
      final packageRef = FirebaseFirestore.instance
          .collection(firestoreConstants.packagesCollection) // 수정된 부분
          .doc(packageId);

      final packageSnapshot = await packageRef.get();
      if (packageSnapshot.exists) {
        final currentViewCount = packageSnapshot.data()?['viewCount'] ?? 0;
        await packageRef.update({'viewCount': currentViewCount + 1});
      } else {
        print('패키지 문서를 찾을 수 없습니다.');
      }
    } catch (e) {
      print('viewCount 업데이트 실패: $e');
    }
  }

  Future<void> _addToScrapList() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print('사용자가 로그인되어 있지 않습니다.');
        return;
      }

      final userRef = FirebaseFirestore.instance
          .collection(firestoreConstants.usersCollection) // 수정된 부분
          .doc(currentUser.uid);
      final userSnapshot = await userRef.get();
      if (userSnapshot.exists) {
        final data = userSnapshot.data();
        List<String> scrapIdList =
            List<String>.from(data?['scrapIdList'] ?? []);

        if (scrapIdList.contains(package?.id)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('이미 담긴 패키지입니다.')),
          );
        } else {
          scrapIdList.add(package?.id ?? '');
          await userRef.update({'scrapIdList': scrapIdList});
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('패키지가 담겼습니다.')),
          );
        }
      } else {
        print('사용자 데이터를 찾을 수 없습니다.');
      }
    } catch (e) {
      print('오류 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (package == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary_450,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
          title: Text(
        package?.title ?? '패키지 상세',
        style: AppTypography.headline4.copyWith(
          color: AppColors.grayScale_950,
        ),
      )),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PackageDetailImage(
              imagePath: package?.imageUrl ?? '',
              onImageSelected: (String value) {},
            ),
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
                onSelectDay: (day) {
                  setState(() {
                    selectedDay = day;
                  });
                },
                selectedDay: selectedDay,
              ),
            ),
            Padding(
              padding: AppSpacing.medium16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var schedule in scheduleMap[selectedDay] ?? [])
                    Builder(
                      builder: (context) {
                        try {
                          final scheduleData = {
                            'id': schedule.id ?? 'ID 없음',
                            'time': schedule.time?.toString() ?? '시간 정보 없음',
                            'title': schedule.title ?? '제목 없음',
                            'location': schedule.location ?? '위치 정보 없음',
                            'content': schedule.content ?? '내용 없음',
                            'imageUrl': schedule.imageUrl ?? '',
                            'day': schedule.day?.toString() ?? '0',
                          };

                          scheduleData.forEach((key, value) {
                            if (value == null) {
                              print('경고: $key 필드가 null입니다.');
                            }
                          });

                          return Padding(
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
                              onSave:
                                  (time, title, location, content, index) {},
                              onDelete: (dayIndex, scheduleIndex) {},
                              key: ValueKey(selectedDay),
                            ),
                          );
                        } catch (e, stacktrace) {
                          print('❌ DetailScheduleList 오류 발생: $e');
                          print('문제의 스케줄 데이터: ${schedule.toString()}');
                          print('Stacktrace: $stacktrace');

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '❗ 이 스케줄을 불러오는 중 오류가 발생했습니다.',
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }
                      },
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
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
      decoration: const BoxDecoration(
        color: AppColors.grayScale_150,
      ),
    );
  }
}

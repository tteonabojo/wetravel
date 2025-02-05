import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/domain/entity/package.dart';
import 'package:wetravel/domain/entity/schedule.dart';
import 'package:wetravel/domain/usecase/get_package_usecase.dart';
import 'package:wetravel/domain/usecase/get_schedules_usecase.dart';
import 'package:wetravel/presentation/pages/guidepackagedetailpage/widgets/detail_schedule_list.dart';
import 'package:wetravel/presentation/pages/guidepackagedetailpage/widgets/package_detail_header.dart';
import 'package:wetravel/presentation/pages/guidepackagedetailpage/widgets/package_detail_image.dart';
import 'package:wetravel/presentation/pages/guidepackagedetailpage/widgets/detail_day_chip_button.dart';

class PackageDetailPage extends StatefulWidget {
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

class _PackageDetailPageState extends State<PackageDetailPage> {
  int selectedDay = 1;
  Package? package;
  Map<int, List<Schedule>> scheduleMap = {};

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
      print('패키지 데이터 로드 시작: ${widget.packageId}');
      final fetchedPackage = await getPackageUseCase.execute(widget.packageId);
      print('패키지 데이터 로드 완료: ${fetchedPackage.toString()}');

      if (fetchedPackage.scheduleIdList == null ||
          fetchedPackage.scheduleIdList!.isEmpty) {
        throw Exception('패키지에 연결된 스케줄이 없습니다.');
      }

      print('스케줄 ID 목록: ${fetchedPackage.scheduleIdList}');
      final schedules =
          await getSchedulesUseCase.execute(fetchedPackage.scheduleIdList!);
      print('스케줄 데이터 로드 완료: ${schedules.toString()}');

      final tempScheduleMap = <int, List<Schedule>>{};

      for (var schedule in schedules) {
        print('스케줄 처리 중: ${schedule.toString()}');
        tempScheduleMap.putIfAbsent(schedule.day, () => []).add(schedule);
      }

      setState(() {
        package = fetchedPackage;
        scheduleMap = tempScheduleMap;
      });
    } catch (e, stacktrace) {
      print('Error loading data: $e');
      print('Stacktrace: $stacktrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (package == null || scheduleMap.isEmpty) {
      return const Center();
    }

    return Scaffold(
      appBar: AppBar(title: Text(package!.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PackageDetailImage(
              imagePath: package!.imageUrl ?? '',
              onImageSelected: (String value) {},
            ),
            PackageDetailHeader(
              title: package!.title,
              keywordList: package!.keywordList ?? [],
              location: package!.location,
              onUpdate: (newTitle, newKeywordList, newLocation) {},
            ),
            divider(1),
            Padding(
              padding: EdgeInsets.only(left: 16, top: 16),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var schedule in scheduleMap[selectedDay] ?? [])
                    DetailScheduleList(
                      schedules: [
                        {
                          'time': schedule.time ?? '', // Null 방지
                          'title': schedule.title ?? '제목 없음',
                          'location': schedule.location ?? '위치 정보 없음',
                          'content': schedule.content ?? '',
                          'imageUrl': schedule.imageUrl ?? '',
                        }
                      ],
                      totalScheduleCount: scheduleMap[selectedDay]?.length ?? 0,
                      dayIndex: selectedDay - 1,
                      onSave: (time, title, location, content, index) {},
                      onDelete: (dayIndex, scheduleIndex) {},
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
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

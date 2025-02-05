import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/domain/entity/package.dart';
import 'package:wetravel/domain/entity/schedule.dart';
import 'package:wetravel/domain/usecase/get_package_usecase.dart';
import 'package:wetravel/domain/usecase/get_schedules_usecase.dart';
import 'package:wetravel/presentation/pages/guide/package_edit_page/package_edit_page.dart';
import 'package:wetravel/presentation/pages/guidepackagedetailpage/widgets/detail_schedule_list.dart';
import 'package:wetravel/presentation/pages/guidepackagedetailpage/widgets/package_detail_header.dart';
import 'package:wetravel/presentation/pages/guidepackagedetailpage/widgets/package_detail_image.dart';
import 'package:wetravel/presentation/pages/guidepackagedetailpage/widgets/detail_day_chip_button.dart';
import 'package:wetravel/presentation/widgets/buttons/standard_button.dart';

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

      final scheduleIdList = fetchedPackage!.scheduleIdList;
      if (scheduleIdList == null || scheduleIdList.isEmpty) {
        throw Exception('패키지에 연결된 스케줄이 없습니다.');
      }

      print('스케줄 ID 목록: $scheduleIdList');
      final schedules = await getSchedulesUseCase.execute(scheduleIdList);
      print('스케줄 데이터 로드 완료: ${schedules.toString()}');

      final tempScheduleMap = <int, List<Schedule>>{};

      for (var schedule in schedules) {
        if (schedule.day == null) {
          print('경고: 스케줄에 day 정보가 없습니다. 스케줄 ID: ${schedule.id}');
          continue; // day가 null인 경우 무시
        }
        tempScheduleMap.putIfAbsent(schedule.day!, () => []).add(schedule);
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
    if (package == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(package?.title ?? '패키지 상세')),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var schedule in scheduleMap[selectedDay] ?? [])
                    Builder(
                      builder: (context) {
                        try {
                          // Null 체크를 위한 디버깅 출력
                          print('디버깅: 스케줄 데이터 - ${schedule.toString()}');

                          final scheduleData = {
                            'id': schedule.id ?? 'ID 없음', // ID가 null일 수도 있음
                            'time': schedule.time?.toString() ?? '시간 정보 없음',
                            'title': schedule.title ?? '제목 없음',
                            'location': schedule.location ?? '위치 정보 없음',
                            'content': schedule.content ?? '내용 없음',
                            'imageUrl': schedule.imageUrl ?? '', // 안전 처리
                            'day': schedule.day?.toString() ?? '0', // day도 체크
                          };

                          // null 값이 있는지 확인
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
                  StandardButton.primary(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PackageEditPage(packageId: package!.id)));
                    },
                    sizeType: ButtonSizeType.normal,
                    text: '수정하기',
                  ),
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

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/data/dto/schedule_dto.dart';
import 'package:wetravel/presentation/pages/guide/package_register_page/widgets/package_header.dart';
import 'package:wetravel/presentation/pages/guide/package_register_page/widgets/package_hero_image.dart';
import 'package:wetravel/presentation/pages/guide/package_register_page/widgets/schedule_list.dart';
import 'package:wetravel/presentation/pages/guide/package_register_page/widgets/widgets/buttons/add_schedule_button.dart';
import 'package:wetravel/presentation/pages/guide/package_register_page/widgets/widgets/buttons/day_chip_button.dart';
import 'package:wetravel/presentation/pages/guide/package_register_page/widgets/widgets/buttons/delete_day_button.dart';
import 'package:wetravel/presentation/pages/guide/package_register_page/widgets/widgets/package_register_service.dart';
import 'package:wetravel/presentation/pages/stack/stack_page.dart';
import 'package:wetravel/presentation/widgets/buttons/standard_button.dart';

class PackageRegisterPage extends StatefulWidget {
  const PackageRegisterPage({super.key});

  @override
  _PackageRegisterPageState createState() => _PackageRegisterPageState();
}

class _PackageRegisterPageState extends State<PackageRegisterPage> {
  String _selectedImagePath = "";
  String _title = '';
  List<String> _keywordList = [];
  String _location = '';
  int _dayCount = 1;
  int _selectedDay = 1;
  final List<List<Map<String, String>>> _schedules = [[]];
  final GlobalKey<PackageHeaderState> _packageHeaderKey =
      GlobalKey<PackageHeaderState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void _onDelete(int dayIndex, int scheduleIndex) {
    setState(() {
      _schedules[dayIndex].removeAt(scheduleIndex);
    });
  }

  void _onAddSchedule() {
    if (_schedules[_selectedDay - 1].length < 9) {
      setState(() {
        _schedules[_selectedDay - 1].add({
          'time': '',
          'title': '',
          'location': '',
          'content': '',
        });
      });
    }
  }

  void _onEditSchedule(int dayIndex, int scheduleIndex, String time,
      String title, String location, String content) {
    if (dayIndex < _schedules.length &&
        scheduleIndex < _schedules[dayIndex].length) {
      setState(() {
        _schedules[dayIndex][scheduleIndex] = {
          'time': time,
          'title': title,
          'location': location,
          'content': content,
        };
      });
    } else {
      print("Invalid index: dayIndex=$dayIndex, scheduleIndex=$scheduleIndex");
    }
  }

  void _onAddDay() {
    if (_dayCount < 10) {
      setState(() {
        _dayCount++;
        _schedules.add([]);
      });
    }
  }

  void _onSelectDay(int day) {
    setState(() {
      _selectedDay = day;
    });
  }

  void _deleteDay() {
    setState(() {
      _schedules.removeAt(_selectedDay - 1);
      _dayCount--;
      if (_selectedDay > _dayCount) {
        _selectedDay = _dayCount;
      }
    });
  }

  final _packageRegisterService = PackageRegisterService();

  void _registerPackage() async {
    setState(() {
      isLoading = true;
    });

    if (_selectedImagePath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지를 등록해주세요.')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    bool hasSchedule =
        _schedules.any((daySchedules) => daySchedules.isNotEmpty);

    if (!hasSchedule) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('일정을 등록해주세요.')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    List<Map<String, dynamic>> scheduleList = [];

    for (var i = 0; i < _schedules.length; i++) {
      for (var j = 0; j < _schedules[i].length; j++) {
        scheduleList.add({
          'day': i + 1,
          'time': _schedules[i][j]['time'],
          'title': _schedules[i][j]['title'],
          'location': _schedules[i][j]['location'],
          'content': _schedules[i][j]['content'],
          'imageUrl': '',
          'order': j + 1,
        });
      }
    }

    String? imageUrl = await _uploadImageToFirebaseStorage(_selectedImagePath);

    if (imageUrl != null) {
      try {
        await _packageRegisterService.registerPackage(
          title: _title,
          location: _location,
          imageUrl: imageUrl,
          keywordList: _keywordList,
          scheduleList: scheduleList,
          isHidden: true,
        );

        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('패키지 등록 성공')),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => StackPage(initialIndex: 2)),
          (route) => false,
        );
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('패키지 등록 실패: $e')),
        );
      }
    }
  }

  Future<String?> _uploadImageToFirebaseStorage(String imagePath) async {
    try {
      String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      File file = File(imagePath);

      TaskSnapshot uploadTask =
          await FirebaseStorage.instance.ref().child(fileName).putFile(file);

      String downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_schedules.length < _selectedDay) {
      _schedules.add([]);
    }

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: GestureDetector(
              onTap: () {
                _packageHeaderKey.currentState!.showEditBottomSheet();
              },
              child: Text(
                _title.isEmpty ? '제목을 입력해주세요' : _title,
                style: AppTypography.headline4.copyWith(
                    color: _title.isEmpty
                        ? AppColors.grayScale_350
                        : AppColors.grayScale_950),
              ),
            ),
            leading: IconButton(
              icon: SvgPicture.asset(AppIcons.chevronLeft),
              onPressed: isLoading ? null : () => Navigator.pop(context),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration:
                            BoxDecoration(color: AppColors.grayScale_050),
                        child: Column(
                          children: [
                            PackageHeroImage(
                              imagePath: _selectedImagePath,
                              onImageSelected: (newPath) {
                                if (!isLoading) {
                                  setState(() {
                                    _selectedImagePath = newPath;
                                  });
                                }
                              },
                            ),
                            PackageHeader(
                              key: _packageHeaderKey,
                              title: _title,
                              keywordList: _keywordList,
                              location: _location,
                              onUpdate:
                                  (newTitle, newKeywordList, newLocation) {
                                if (!isLoading) {
                                  setState(() {
                                    _title = newTitle;
                                    _keywordList = newKeywordList;
                                    _location = newLocation;
                                  });
                                }
                              },
                            ),
                            divider(1),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DayChipButton(
                                    onPressed: _onAddDay,
                                    currentDayCount: _dayCount,
                                    onSelectDay: _onSelectDay,
                                    selectedDay: _selectedDay,
                                  ),
                                  SizedBox(height: 16),
                                  ScheduleList(
                                    schedules: _schedules[_selectedDay - 1]
                                        .map((scheduleMap) =>
                                            ScheduleDto.fromJson(scheduleMap))
                                        .toList(),
                                    totalScheduleCount:
                                        _schedules[_selectedDay - 1].length,
                                    dayIndex: _selectedDay - 1,
                                    onSave: (time, title, location, content,
                                        scheduleIndex) {
                                      _onEditSchedule(
                                        _selectedDay - 1,
                                        scheduleIndex,
                                        time,
                                        title,
                                        location,
                                        content,
                                      );
                                    },
                                    onDelete: _onDelete,
                                  ),
                                  AddScheduleButton(
                                    onPressed:
                                        isLoading ? null : _onAddSchedule,
                                    currentScheduleCount:
                                        _schedules[_selectedDay - 1].length,
                                  ),
                                  if (_dayCount > 1)
                                    Column(
                                      children: [
                                        SizedBox(height: 12),
                                        DeleteDayButton(
                                          onPressed:
                                              isLoading ? null : _deleteDay,
                                        ),
                                      ],
                                    ),
                                  const SizedBox(height: 40),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            padding: AppSpacing.medium16.copyWith(bottom: 30),
            child: StandardButton.primary(
              onPressed: isLoading ? null : _registerPackage,
              sizeType: ButtonSizeType.normal,
              text: '작성 완료',
            ),
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
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

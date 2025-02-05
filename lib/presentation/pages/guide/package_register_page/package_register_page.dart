import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_colors.dart';
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
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  String _selectedImagePath = "";
  String _title = '제목';
  List<String> _keywordList = ['2박 3일', '혼자', '액티비티'];
  String _location = '위치';
  int _dayCount = 1;
  int _selectedDay = 1;
  final List<List<Map<String, String>>> _schedules = [[]];

  bool isLoading = false;

  void _onDelete(int dayIndex, int scheduleIndex) {
    setState(() {
      _schedules[dayIndex].removeAt(scheduleIndex);
    });
  }

  void _onAddSchedule() {
    if (_schedules[_selectedDay - 1].length < 9) {
      setState(() {
        _schedules[_selectedDay - 1].add({
          'time': '오전 9:00',
          'title': '제목',
          'location': '위치',
          'content': '설명',
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
      return;
    }

    bool hasSchedule =
        _schedules.any((daySchedules) => daySchedules.isNotEmpty);

    if (!hasSchedule) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('일정을 등록해주세요.')),
      );
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
          description: _descriptionController.text,
          duration: _durationController.text,
          imageUrl: imageUrl,
          keywordList: _keywordList,
          scheduleList: scheduleList,
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

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: AppColors.grayScale_050),
              child: Column(
                children: [
                  PackageHeroImage(
                    imagePath: _selectedImagePath,
                    onImageSelected: (newPath) {
                      print('Selected image path: $newPath');
                      setState(() {
                        _selectedImagePath = newPath;
                      });
                    },
                  ),
                  PackageHeader(
                    title: _title,
                    keywordList: _keywordList,
                    location: _location,
                    onUpdate: (newTitle, newKeywordList, newLocation) {
                      setState(() {
                        _title = newTitle;
                        _keywordList = newKeywordList;
                        _location = newLocation;
                      });
                    },
                  ),
                  divider(1),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Column(
                      spacing: 16,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DayChipButton(
                          onPressed: _onAddDay,
                          currentDayCount: _dayCount,
                          onSelectDay: _onSelectDay,
                          selectedDay: _selectedDay,
                        ),
                        ScheduleList(
                          schedules: _schedules[_selectedDay - 1]
                              .map((scheduleMap) =>
                                  ScheduleDto.fromMap(scheduleMap))
                              .toList(),
                          totalScheduleCount:
                              _schedules[_selectedDay - 1].length,
                          dayIndex: _selectedDay - 1,
                          onSave:
                              (time, title, location, content, scheduleIndex) {
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
                          onPressed: _onAddSchedule,
                          currentScheduleCount:
                              _schedules[_selectedDay - 1].length,
                        ),
                        if (_dayCount > 1)
                          DeleteDayButton(
                            onPressed: _deleteDay,
                          ),
                        const SizedBox(height: 40),
                        StandardButton.primary(
                          onPressed: _registerPackage,
                          sizeType: ButtonSizeType.normal,
                          text: '작성 완료',
                        ),
                      ],
                    ),
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

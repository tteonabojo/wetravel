import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uuid/uuid.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/core/constants/firestore_constants.dart';
import 'package:wetravel/data/dto/schedule_dto.dart';
import 'package:wetravel/presentation/pages/guide/package_edit_page/edit_schedule_list.dart';
import 'package:wetravel/presentation/pages/guide/package_edit_page/package_edit_image.dart';
import 'package:wetravel/presentation/pages/guide/package_register_page/widgets/package_header.dart';
import 'package:wetravel/presentation/pages/guide/package_register_page/widgets/widgets/buttons/add_schedule_button.dart';
import 'package:wetravel/presentation/pages/guide/package_register_page/widgets/widgets/buttons/day_chip_button.dart';
import 'package:wetravel/presentation/pages/guide/package_register_page/widgets/widgets/buttons/delete_day_button.dart';
import 'package:wetravel/presentation/pages/guide/package_register_page/widgets/widgets/package_register_service.dart';
import 'package:wetravel/presentation/widgets/buttons/standard_button.dart';

class PackageEditPage extends StatefulWidget {
  final String packageId;
  const PackageEditPage({super.key, required this.packageId});

  @override
  _PackageEditPageState createState() => _PackageEditPageState();
}

class _PackageEditPageState extends State<PackageEditPage> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  final FirestoreConstants firestoreConstants = FirestoreConstants();

  String _selectedImagePath = "";
  String _title = '';
  List<String> _keywordList = [];
  String _location = '';
  int _dayCount = 1;
  int _selectedDay = 1;
  final List<List<ScheduleDto>> _schedules = [[]];
  final GlobalKey<PackageHeaderState> _packageHeaderKey = GlobalKey();
  bool isLoading = true;
  bool isPublic = true;

  @override
  void initState() {
    super.initState();
    _loadPackageData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('일정 카드를 길게 눌러 순서변경이 가능합니다.')),
      );
    });
  }

  Future<void> _loadPackageData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection(firestoreConstants.packagesCollection)
          .doc(widget.packageId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;

        final scheduleIdList = List<String>.from(data['scheduleIdList'] ?? []);

        final List<List<ScheduleDto>> loadedSchedules = [];

        for (String scheduleId in scheduleIdList) {
          final scheduleDoc = await FirebaseFirestore.instance
              .collection(firestoreConstants.schedulesCollection)
              .doc(scheduleId)
              .get();

          final scheduleData = scheduleDoc.data();
          if (scheduleData != null) {
            final schedule =
                ScheduleDto.fromJson({...scheduleData, "id": scheduleDoc.id});
            final day = schedule.day;

            while (loadedSchedules.length < day) {
              loadedSchedules.add([]);
            }

            loadedSchedules[day - 1].add(schedule);
          } else {
            print('스케줄 데이터를 불러오는 데 실패했습니다.');
          }
        }

        setState(() {
          _selectedImagePath = data['imageUrl'] ?? '';
          _title = data['title'] ?? '제목';
          _location = data['location'] ?? '위치';
          _keywordList = List<String>.from(data['keywordList'] ?? []);
          _descriptionController.text = data['description'] ?? '';
          _durationController.text = data['duration'] ?? '';
          isPublic = !data['isHidden'];
          _dayCount = loadedSchedules.isNotEmpty ? loadedSchedules.length : 1;
          _schedules.clear();
          _schedules.addAll(loadedSchedules);
          isLoading = false;
        });
      }
    } catch (e) {
      print('패키지 데이터 불러오기 실패: $e');
    }
  }

  void _onDelete(int dayIndex, int scheduleIndex) async {
    if (dayIndex < _schedules.length &&
        scheduleIndex < _schedules[dayIndex].length) {
      final scheduleToDelete = _schedules[dayIndex][scheduleIndex];

      try {
        await FirebaseFirestore.instance
            .collection(firestoreConstants.schedulesCollection)
            .doc(scheduleToDelete.id)
            .delete();

        setState(() {
          _schedules[dayIndex].removeAt(scheduleIndex);
        });
      } catch (e) {
        print('스케줄 삭제 실패: $e');
      }
    }
  }

  final Uuid uuid = Uuid();

  void _onAddSchedule() {
    if (_schedules[_selectedDay - 1].length < 9) {
      setState(() {
        _schedules[_selectedDay - 1].add(
          ScheduleDto(
            id: uuid.v4(),
            time: '',
            title: '',
            location: '',
            content: '',
            day: _selectedDay,
            order: _schedules[_selectedDay - 1].length + 1,
            packageId: '',
            duration: '',
            imageUrl: '',
            isAIRecommended: false,
            travelStyle: '',
          ),
        );
      });
    }
  }

  void _onEditSchedule(int dayIndex, int scheduleIndex, String time,
      String title, String location, String content) {
    if (dayIndex < _schedules.length &&
        scheduleIndex < _schedules[dayIndex].length) {
      setState(() {
        final existingSchedule = _schedules[dayIndex][scheduleIndex];
        _schedules[dayIndex][scheduleIndex] = ScheduleDto(
          id: existingSchedule.id,
          time: time,
          title: title,
          location: location,
          content: content,
          day: existingSchedule.day,
          order: existingSchedule.order,
          packageId: existingSchedule.packageId,
          duration: existingSchedule.duration,
          imageUrl: existingSchedule.imageUrl,
          isAIRecommended: existingSchedule.isAIRecommended,
          travelStyle: existingSchedule.travelStyle,
        );
      });
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
    if (_selectedDay <= 0 || _selectedDay > _dayCount) return;

    setState(() {
      _schedules.removeAt(_selectedDay - 1);
      _dayCount--;
      if (_selectedDay > _dayCount) {
        _selectedDay = _dayCount;
      }
    });
  }

  final _packageRegisterService = PackageRegisterService();

  void _updatePackage() async {
    if (_title.isEmpty ||
        _location.isEmpty ||
        _selectedImagePath.isEmpty ||
        _keywordList.isEmpty ||
        _schedules.expand((day) => day).isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 일정의 필드를 입력해주세요.')),
      );
      return;
    }

    // EditScheduleList의 각 필드 유효성 검사
    for (var daySchedules in _schedules) {
      for (var schedule in daySchedules) {
        if (schedule.time.isEmpty ||
            schedule.title.isEmpty ||
            schedule.location.isEmpty ||
            schedule.content.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('모든 일정의 필드를 입력해주세요.')),
          );
          return;
        }
      }
    }

    setState(() {
      isLoading = true;
    });

    String imageUrl = _selectedImagePath.startsWith('http')
        ? _selectedImagePath
        : (await _uploadImageToFirebaseStorage(_selectedImagePath)) ?? '';

    if (imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지를 등록해주세요.')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      await _packageRegisterService.updatePackage(
        packageId: widget.packageId,
        title: _title,
        location: _location,
        description: _descriptionController.text,
        duration: _durationController.text,
        imageUrl: imageUrl,
        keywordList: _keywordList,
        scheduleList: _schedules.expand((daySchedules) {
          return daySchedules.asMap().entries.map((entry) {
            final schedule = entry.value;
            return {
              'id': schedule.id,
              'time': schedule.time,
              'title': schedule.title,
              'location': schedule.location,
              'content': schedule.content,
              'day': schedule.day,
              'order': schedule.order
            };
          });
        }).toList(),
        isHidden: !isPublic,
        context: context,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('패키지 수정 성공')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('패키지 수정 실패: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
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
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary_450,
          ),
        ),
      );
    }

    if (_schedules.length < _selectedDay) {
      _schedules.add([]);
    }

    return Scaffold(
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: AppColors.grayScale_050),
              child: Column(
                children: [
                  PackageEditImage(
                    initialImageUrl: _selectedImagePath,
                    onImageSelected: (newPath) {
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
                    key: _packageHeaderKey,
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
                        EditScheduleList(
                          schedules: _schedules[_selectedDay - 1],
                          totalScheduleCount:
                              _schedules[_selectedDay - 1].length,
                          dayIndex: _selectedDay - 1,
                          onSave:
                              (time, title, location, content, scheduleIndex) {
                            _onEditSchedule(_selectedDay - 1, scheduleIndex,
                                time, title, location, content);
                          },
                          onDelete: (dayIndex, scheduleIndex) {
                            _onDelete(dayIndex, scheduleIndex);
                          },
                          onReorder: (oldIndex, newIndex) => _onReorderSchedule(
                              _selectedDay - 1, oldIndex, newIndex),
                        ),
                        AddScheduleButton(
                          onPressed: _onAddSchedule,
                          currentScheduleCount:
                              _schedules[_selectedDay - 1].length,
                        ),
                        if (_dayCount > 1)
                          Column(
                            children: [
                              SizedBox(height: 12),
                              DeleteDayButton(
                                onPressed: isLoading ? null : _deleteDay,
                              ),
                            ],
                          ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  '공개하기',
                                  style:
                                      AppTypography.buttonLabelMedium.copyWith(
                                    color: AppColors.grayScale_650,
                                  ),
                                ),
                              ),
                              CupertinoSwitch(
                                activeColor: AppColors.primary_450,
                                value: isPublic,
                                onChanged: (bool value) {
                                  setState(() {
                                    isPublic = value;
                                  });
                                },
                              ),
                            ],
                          ),
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
      bottomNavigationBar: Container(
        padding: AppSpacing.medium16.copyWith(bottom: 30),
        child: StandardButton.primary(
          onPressed: _updatePackage,
          sizeType: ButtonSizeType.normal,
          text: '수정 완료',
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

  void _onReorderSchedule(int dayIndex, int oldIndex, int newIndex) {
    setState(() {
      final item = _schedules[dayIndex].removeAt(oldIndex);
      _schedules[dayIndex].insert(newIndex, item);
    });
  }
}

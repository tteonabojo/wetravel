import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/presentation/pages/guide/widgets/chip_button_list.dart';
import 'package:wetravel/presentation/pages/guide/widgets/itinerary_header.dart';
import 'package:wetravel/presentation/pages/guide/widgets/itinerary_hero_image.dart';
import 'package:wetravel/presentation/pages/guide/widgets/itinerary_list.dart';
import 'package:wetravel/presentation/widgets/buttons/add_itinerary_button.dart';
import 'package:wetravel/presentation/widgets/buttons/standard_button.dart';

class PackageRegisterPage extends StatefulWidget {
  const PackageRegisterPage({super.key});

  @override
  _PackageRegisterPageState createState() => _PackageRegisterPageState();
}

class _PackageRegisterPageState extends State<PackageRegisterPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  String _selectedImagePath = "assets/images/cherry_blossom.png"; // 기본 이미지

  List<int> itineraries = [0];

  // Itinerary 삭제 함수
  void _onDelete(int index) {
    setState(() {
      itineraries.removeAt(index); // 해당 인덱스의 Itinerary 삭제
    });
  }

  // Itinerary 추가 함수
  void _onAddItinerary() {
    setState(() {
      itineraries.add(itineraries.length); // 새로운 Itinerary 추가
    });
  }

  // 패키지 등록 함수
  Future<void> _registerPackage() async {
    final user = FirebaseAuth.instance.currentUser; // 현재 로그인한 사용자 정보

    final packageData = {
      'id': FirebaseFirestore.instance.collection('packages').doc().id,
      'userId': user!.uid,
      'title': _titleController.text,
      'location': _locationController.text,
      'description': _descriptionController.text,
      'duration': _durationController.text,
      'imageUrl': _selectedImagePath,
      'keywordList': [],
      'scheduleIdList': [],
      'createdAt': Timestamp.now(),
      'reportCount': 0,
      'isHidden': false,
    };

    try {
      await FirebaseFirestore.instance
          .collection('packages')
          .doc(packageData['id'] as String?)
          .set(packageData);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('패키지 등록 성공')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('패키지 등록 실패: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  ItineraryHeroImage(
                    imagePath: _selectedImagePath,
                    onImageSelected: (newPath) {
                      setState(() {
                        _selectedImagePath = newPath;
                      });
                    },
                  ),
                  ItineraryHeader(),
                  divider(1),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Column(
                      spacing: 16,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ChipButtonList(),
                        Column(
                          spacing: 16,
                          children: itineraries.asMap().entries.map((entry) {
                            return ItineraryList(
                              key: Key('itinerary_${entry.key}'),
                              onDelete: _onDelete,
                              isFirstItem: entry.key == 0, // 첫 번째 항목에만 true
                            );
                          }).toList(),
                        ),
                        AddItineraryButton(
                          onPressed: _onAddItinerary,
                        ),
                        SizedBox(height: 40),
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

  // 가로 경계선
  Container divider(double height) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.grayScale_150,
      ),
    );
  }
}

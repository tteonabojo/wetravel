import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/core/constants/firestore_constants.dart';
import 'package:wetravel/presentation/pages/guide_package/widgets/filterd_package_list.dart';
import 'package:wetravel/presentation/pages/guide_package/widgets/filters.dart';
import 'package:wetravel/presentation/provider/survey_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/presentation/pages/stack/stack_page.dart';

/// 선택한 키워드를 모아서 보여주는 페이지
class FilteredGuidePackagePage extends ConsumerWidget {
  const FilteredGuidePackagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(surveyProvider);
    final FirestoreConstants firestoreConstants = FirestoreConstants();

    final selectedKeywords = [
      if (state.selectedCity != null && state.selectedCity!.isNotEmpty)
        {
          'value': (state.selectedCity is List<String>)
              ? (state.selectedCity as List<String>).join(', ')
              : state.selectedCity
        },
      if (state.travelPeriod != null) {'value': state.travelPeriod},
      if (state.travelDuration != null) {'value': state.travelDuration},
      if (state.companion != null) {'value': state.companion},
      if (state.travelStyle != null) {'value': state.travelStyle},
      if (state.accommodationType != null) {'value': state.accommodationType},
      if (state.consideration != null) {'value': state.consideration},
    ].map((keyword) => keyword['value']).whereType<String>().toList();

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Container(color: AppColors.grayScale_150, height: 1)),
        backgroundColor: Colors.white,
        title: Text('가이드 맞춤 패키지 추천', style: AppTypography.headline4),
        leading: null,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (context) {
                  return StackPage();
                },
              ), (route) => false);
            },
            child: Padding(
              padding: EdgeInsets.only(right: 16),
              child: SvgPicture.asset(AppIcons.x),
            ),
          )
        ],
      ),
      body: selectedKeywords.isNotEmpty
          ? FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection(firestoreConstants.packagesCollection)
                  .where('keywordList', arrayContainsAny: selectedKeywords)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: AppColors.primary_450,
                  ));
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading data'));
                }

                final packages = snapshot.data?.docs ?? [];

                if (packages.isEmpty) {
                  return const Center(child: Text('조건에 맞는 패키지가 없습니다.'));
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GuideFilters(
                      selectedKeywords: selectedKeywords,
                    ),
                    Expanded(
                      child: FilteredPackageList(
                        selectedKeywords: selectedKeywords,
                      ),
                    ),
                  ],
                );
              },
            )
          : const Center(
              child: Text(
                '선택된 키워드가 없습니다.',
                style: AppTypography.body2,
              ),
            ),
    );
  }
}

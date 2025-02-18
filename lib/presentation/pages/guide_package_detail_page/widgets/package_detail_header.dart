import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/core/constants/firestore_constants.dart';

class PackageDetailHeader extends StatefulWidget {
  final String title;
  final List<String> keywordList;
  final String location;
  final String? userId;
  final Function(String, List<String>, String) onUpdate;

  const PackageDetailHeader({
    super.key,
    required this.title,
    required this.keywordList,
    required this.location,
    this.userId,
    required this.onUpdate,
  });

  @override
  _PackageDetailHeaderState createState() => _PackageDetailHeaderState();
}

class _PackageDetailHeaderState extends State<PackageDetailHeader> {
  String? userName;
  String? userImageUrl;
  final FirestoreConstants firestoreConstants = FirestoreConstants();

  @override
  void initState() {
    super.initState();
    if (widget.userId != null) {
      _fetchUserInfo();
    }
  }

  /// 사용자 정보를 Firestore에서 가져오기
  Future<void> _fetchUserInfo() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection(firestoreConstants.usersCollection)
          .doc(widget.userId)
          .get();
      if (userDoc.exists) {
        setState(() {
          userName = userDoc['name'];
          userImageUrl = userDoc['imageUrl'];
        });
      } else {
        log("탈퇴한 작성자 userId: ${widget.userId}");
      }
    } catch (e) {
      log("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String?> selectedKeywords = widget.keywordList.isNotEmpty
        ? List.from(widget.keywordList)
        : [null, null, null];

    return Container(
      width: double.infinity,
      height: 116,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                ClipOval(
                  child: Container(
                    width: 24,
                    height: 24,
                    color: AppColors.primary_250,
                    child: userImageUrl?.isNotEmpty ?? false
                        ? Image.network(
                            userImageUrl!,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            margin: AppSpacing.small4,
                            child: SvgPicture.asset(
                              AppIcons.userRound,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    userName?.trim().isNotEmpty ?? false
                        ? userName!
                        : 'no name',
                    style: AppTypography.body2
                        .copyWith(color: AppColors.grayScale_950),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: selectedKeywords
                        .asMap()
                        .entries
                        .map((entry) {
                          final index = entry.key;
                          final keyword = entry.value ?? '키워드 ${index + 1}';
                          return [
                            Text(
                              keyword,
                              style: AppTypography.body2.copyWith(
                                color: AppColors.grayScale_550,
                              ),
                            ),
                            if (index < selectedKeywords.length - 1)
                              const SizedBox(
                                height: 12,
                                child: VerticalDivider(
                                  color: AppColors.grayScale_450,
                                  thickness: 1,
                                  width: 16,
                                ),
                              ),
                          ];
                        })
                        .expand((widget) => widget)
                        .toList(),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    SvgPicture.asset(
                      AppIcons.mapPin,
                      color: AppColors.grayScale_550,
                      height: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.location,
                      style: AppTypography.body2.copyWith(
                        color: AppColors.grayScale_550,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

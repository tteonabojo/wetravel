import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/firestore_constants.dart';
import 'package:wetravel/domain/entity/package.dart';
import 'package:wetravel/presentation/provider/package_provider.dart';

final firestoreConstantsProvider =
    Provider<FirestoreConstants>((ref) => FirestoreConstants());

class AdminPageViewModel extends ChangeNotifier {
  final Ref ref;
  String selectedFilter = '전체 패키지';
  bool showHiddenPackages = false;
  List<Package> packages = [];
  bool isLoading = false;
  String? errorMessage;

  AdminPageViewModel({required this.ref}) {
    loadPackages();
  }

  void setSelectedFilter(String filter) {
    selectedFilter = filter;
    notifyListeners();
  }

  Future<void> loadPackages() async {
    isLoading = true;
    notifyListeners();
    try {
      packages = await ref.read(packagesProvider.future);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleIsHidden(String packageId, bool currentStatus) async {
    try {
      final firestoreConstants = ref.read(firestoreConstantsProvider);
      await FirebaseFirestore.instance
          .collection(firestoreConstants.packagesCollection)
          .doc(packageId)
          .update({'isHidden': !currentStatus});
      showHiddenPackages = !showHiddenPackages;
      loadPackages();
      notifyListeners();
    } catch (e) {
      print('isHidden 변경 실패: $e');
    }
  }

  Future<void> deletePackage(String packageId) async {
    try {
      final firestoreConstants = ref.read(firestoreConstantsProvider);
      final packageDoc = await FirebaseFirestore.instance
          .collection(firestoreConstants.packagesCollection)
          .doc(packageId)
          .get();

      if (packageDoc.exists) {
        final imageUrl = packageDoc.data()?['imageUrl'] as String?;

        if (imageUrl != null && imageUrl.isNotEmpty) {
          final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
          await storageRef.delete();
        }
      }

      final schedulesQuerySnapshot = await FirebaseFirestore.instance
          .collection(firestoreConstants.schedulesCollection)
          .where('packageId', isEqualTo: packageId)
          .get();

      await FirebaseFirestore.instance
          .collection(firestoreConstants.packagesCollection)
          .doc(packageId)
          .delete();

      for (var scheduleDoc in schedulesQuerySnapshot.docs) {
        await scheduleDoc.reference.delete();
      }

      loadPackages();
      notifyListeners();
    } catch (e) {
      print('패키지 및 관련 스케줄 삭제 실패: $e');
    }
  }

  List<Package> getFilteredPackages() {
    return packages.where((package) {
      if (selectedFilter == '공개 패키지') {
        return !package.isHidden;
      } else if (selectedFilter == '비공개 패키지') {
        return package.isHidden;
      }
      return true;
    }).toList();
  }
}

final adminPageViewModelProvider =
    ChangeNotifierProvider.autoDispose((ref) => AdminPageViewModel(ref: ref));

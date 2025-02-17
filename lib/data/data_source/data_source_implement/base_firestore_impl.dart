import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:wetravel/core/constants/firestore_constants.dart';

class BaseFirestoreImpl extends FirestoreConstants {
  final String _collectionName;
  final FirebaseFirestore firestore;
  BaseFirestoreImpl(this._collectionName, this.firestore);

  String get collectionName =>
      kDebugMode ? '${_collectionName}_test' : _collectionName;

  String get userPath => usersCollection;
  String get schedulePath => schedulesCollection;
  String get packagePath => packagesCollection;
  String get bannerPath => bannersCollection;
}

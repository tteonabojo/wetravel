import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

abstract class BaseFirestoreImpl {
  final String _collectionName;
  final FirebaseFirestore firestore;
  BaseFirestoreImpl(this._collectionName, this.firestore);

  String get collectionName =>
      kDebugMode ? '${_collectionName}_test' : _collectionName;
}

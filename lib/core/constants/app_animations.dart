import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppAnimations {
  static const String _photoLoading = 'assets/animations/photo_loading.json';

  static final Widget photoLoading = Center(
    child: Lottie.asset(_photoLoading, width: 150),
  );
}

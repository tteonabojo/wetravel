import 'package:flutter/material.dart';

class AppSpacing {
  static const EdgeInsets zero = EdgeInsets.zero;

  // Padding 설정으로 여백 만들때 all 속성이므로 절반 숫자로 사용할것.
  static const EdgeInsets _4 = EdgeInsets.all(4.0);
  static const EdgeInsets _8 = EdgeInsets.all(8.0);
  static const EdgeInsets _12 = EdgeInsets.all(12.0);
  static const EdgeInsets _16 = EdgeInsets.all(16.0);
  static const EdgeInsets _20 = EdgeInsets.all(20.0);
  static const EdgeInsets _24 = EdgeInsets.all(24.0);
  static const EdgeInsets _28 = EdgeInsets.all(28.0);

  // 무슨 뜻이냐면 -> 16픽셀 여백을 주려면 xsmall(8) 값을 가져다 쓸것. ( 8 * 2 = 16 )
  static const EdgeInsets xxsmall = _4;
  static const EdgeInsets xsmall = _8;
  static const EdgeInsets small = _12;
  static const EdgeInsets medium = _16;
  static const EdgeInsets large = _20;
  static const EdgeInsets xlarge = _24;
  static const EdgeInsets xxlarge = _28;
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wetravel/presentation/pages/banner/widgets/banner_item_label.dart';

class BannerHide extends StatefulWidget {
  /// 배너 숨김 여부
  const BannerHide({super.key});

  @override
  State<BannerHide> createState() => _BannerHideState();
}

class _BannerHideState extends State<BannerHide> {
  bool _isChecked = false;

  void hideBanner(bool value) {
    setState(() {
      _isChecked = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BannerItemLabel(label: '숨기기'),
          SizedBox(
            width: 48,
            child: CupertinoSwitch(
                activeColor: CupertinoColors.activeBlue,
                value: _isChecked,
                onChanged: (bool value) => hideBanner(value)),
          )
        ],
      ),
    );
  }
}

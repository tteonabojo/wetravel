import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/presentation/pages/banner/widgets/banner_item_label.dart';
import 'package:wetravel/presentation/pages/banner/widgets/date_input_field.dart';

class BannerDate extends StatefulWidget {
  /// 배너 기간
  const BannerDate({super.key});

  @override
  State<BannerDate> createState() => _BannerDateState();
}

class _BannerDateState extends State<BannerDate> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(days: 1));
  final dateFormat = DateFormat('yyyy.MM.dd');

  /// 날짜 선택
  void _showDatePicker(BuildContext context, bool isStartDate) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            initialDateTime: isStartDate ? startDate : endDate,
            mode: CupertinoDatePickerMode.date,
            use24hFormat: true,
            dateOrder: DatePickerDateOrder.ymd,
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                if (isStartDate) {
                  startDate = newDate;
                  if (startDate.isAfter(endDate)) {
                    endDate = startDate.add(Duration(days: 1));
                  }
                } else {
                  endDate = newDate;
                  if (endDate.isBefore(startDate)) {
                    startDate = endDate.subtract(Duration(days: 1));
                  }
                }
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: BannerItemLabel(label: ' 시작 날짜')),
              SizedBox(width: 20),
              Expanded(child: BannerItemLabel(label: ' 종료 날짜')),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DateInputField(
                  date: startDate,
                  onTap: () => _showDatePicker(context, true),
                ),
              ),
              SizedBox(
                width: 20,
                child: SvgPicture.asset(AppIcons.dateDash),
              ),
              Expanded(
                child: DateInputField(
                  date: endDate,
                  onTap: () => _showDatePicker(context, false),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

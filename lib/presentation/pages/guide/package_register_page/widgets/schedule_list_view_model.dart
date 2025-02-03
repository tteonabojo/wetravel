import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScheduleListViewModel extends ChangeNotifier {
  ScheduleListViewModel({
    String time = '오전 9:00',
    String title = '제목',
    String location = '위치',
    String content = '설명',
  })  : _time = time,
        _title = title,
        _location = location,
        _content = content;

  String _time;
  String _title;
  String _location;
  String _content;

  String get time => _time;
  String get title => _title;
  String get location => _location;
  String get content => _content;

  void updateSchedule(
      String time, String title, String location, String content) {
    _time = time;
    _title = title;
    _location = location;
    _content = content;
    notifyListeners();
  }
}

final scheduleViewModelProvider =
    ChangeNotifierProvider<ScheduleListViewModel>((ref) {
  return ScheduleListViewModel();
});

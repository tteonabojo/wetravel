import 'package:wetravel/domain/entity/schedule.dart';

class UserModel {
  final String id;
  final String email;
  final List<Schedule> schedules;

  UserModel({
    required this.id,
    required this.email,
    required this.schedules,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    print('Converting JSON to UserModel: $json');
    try {
      final schedulesData = json['schedules'];
      print('Schedules data: $schedulesData');
      final schedules = <Schedule>[];

      if (schedulesData != null && schedulesData is List) {
        schedules.addAll(
          schedulesData.map((e) {
            print('Converting schedule item: $e');
            return Schedule.fromJson(e as Map<String, dynamic>);
          }).toList(),
        );
      }

      final id = json['id'] ?? json['uid'];
      print('Using ID: $id');

      return UserModel(
        id: id ?? '',
        email: json['email'] ?? '',
        schedules: schedules,
      );
    } catch (e, stack) {
      print('Error converting JSON to UserModel: $e');
      print('Stack trace: $stack');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'schedules': schedules.map((e) => e.toJson()).toList(),
      // 추가 필드들이 있다면 여기에 포함
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    List<Schedule>? schedules,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      schedules: schedules ?? this.schedules,
    );
  }
}

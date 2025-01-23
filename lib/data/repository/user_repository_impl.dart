import 'package:wetravel/data/data_source/user_data_source.dart';
import 'package:wetravel/domain/entity/package.dart';
import 'package:wetravel/domain/entity/schedule.dart';
import 'package:wetravel/domain/entity/user.dart';
import 'package:wetravel/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._userDataSource);
  final UserDataSource _userDataSource;

  @override
  Future<List<User>> fetchUsers() async {
    final result = await _userDataSource.fetchUsers();
    return result
        .map(
          (e) => User(
            id: e.id,
            email: e.email,
            password: e.password,
            name: e.name,
            imageUrl: e.imageUrl,
            introduction: e.introduction,
            loginType: e.loginType,
            isGuide: e.isGuide,
            createdAt: e.createdAt,
            updatedAt: e.updatedAt,
            deletedAt: e.deletedAt,
            scrapList: e.scrapList
                ?.map((package) => Package(
                      id: package.id,
                      userId: package.userId,
                      title: package.title,
                      location: package.location,
                      description: package.description,
                      duration: package.duration,
                      imageUrl: package.imageUrl,
                      keywordList: package.keywordList,
                      schedule: package.schedule
                          ?.map((e) => Schedule(
                                id: e.id,
                                packageId: e.packageId,
                                title: e.title,
                                content: e.content,
                                imageUrl: e.imageUrl,
                                order: e.order as int,
                              ))
                          .toList(),
                      createdAt: package.createdAt,
                      updatedAt: package.updatedAt,
                    ))
                .toList(),
          ),
        )
        .toList();
  }
}

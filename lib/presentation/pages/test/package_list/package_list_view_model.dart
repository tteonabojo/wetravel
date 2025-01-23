import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/entity/package.dart';
import 'package:wetravel/presentation/provider/package_provider.dart';

class PackageListViewModel extends Notifier<List<Package>?> {
  @override
  List<Package>? build() {
    fetchPackages();
    return null;
  }

  Future<void> fetchPackages() async {
    state = await ref.watch(fetchPackagesUsecaseProvider).execute();
  }
}

final packageListViewModel =
    NotifierProvider<PackageListViewModel, List<Package>?>(
        () => PackageListViewModel());

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_provider.dart';
import '../domain/auth_repository.dart';
import 'auth_repository_mock.dart';
import 'auth_repository_remote.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final storage = ref.watch(secureTokenStorageProvider);

  if (AppConfig.useMockAuth) {
    return AuthRepositoryMock(storage);
  }

  final dio = ref.watch(dioProvider);
  return AuthRepositoryRemote(dio, storage);
});

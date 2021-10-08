import 'package:dartz/dartz.dart';

import '../errors/errors.dart';
import '../repositories/logout_repository.dart';

abstract class Logout {
  Future<Either<LogoutFailure, Unit>> call();
}

class LogoutImpl implements Logout {
  final LogoutRepository repository;

  const LogoutImpl({required this.repository});

  @override
  Future<Either<LogoutFailure, Unit>> call() async {
    return await repository.logout();
  }
}

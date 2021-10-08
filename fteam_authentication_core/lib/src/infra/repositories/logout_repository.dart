import 'package:dartz/dartz.dart';

import '../../domain/errors/errors.dart';
import '../../domain/repositories/logout_repository.dart';
import '../datasource/auth_datasource.dart';

class LogoutRepositoryImpl implements LogoutRepository {
  final AuthDatasource datasource;

  const LogoutRepositoryImpl({required this.datasource});

  @override
  Future<Either<LogoutFailure, Unit>> logout() async {
    try {
      await datasource.logout();
      return Right(unit);
    } catch (exception, stacktrace) {
      return Left(LogoutFailure(
          message: 'logoutRepositoryImpl.errorMessage',
          mainException: exception,
          stacktrace: stacktrace));
    }
  }
}

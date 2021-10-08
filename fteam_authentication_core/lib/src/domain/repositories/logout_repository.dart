import 'package:dartz/dartz.dart';

import '../errors/errors.dart';

abstract class LogoutRepository {
  Future<Either<LogoutFailure, Unit>> logout();
}

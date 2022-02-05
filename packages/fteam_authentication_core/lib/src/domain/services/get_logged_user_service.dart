import 'package:dartz/dartz.dart';

import '../entities/logged_user.dart';
import '../errors/errors.dart';

abstract class GetLoggedUserService {
  Future<Either<AuthFailure, LoggedUser?>> getUser();
}

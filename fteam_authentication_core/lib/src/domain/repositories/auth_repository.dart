import 'package:dartz/dartz.dart';

import '../entities/logged_user.dart';
import '../errors/errors.dart';
import '../models/email_credencials.dart';

abstract class AuthRepository {
  Future<Either<AuthFailure, LoggedUser?>> googleLogin();
  Future<Either<AuthFailure, LoggedUser?>> appleIdLogin();
  Future<Either<AuthFailure, LoggedUser?>> facebookLogin();
  Future<Either<AuthFailure, Unit>> sendEmailVerification();
  Future<Either<AuthFailure, Unit>> recoveryPassword(String email);
  Future<Either<AuthFailure, LoggedUser?>> emailLogin(
      EmailCredencials credencials);
}

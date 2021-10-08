import 'package:dartz/dartz.dart';

import '../entities/logged_user.dart';
import '../errors/errors.dart';
import '../models/email_credencials.dart';

abstract class SignupWithEmailRepository {
  Future<Either<AuthFailure, LoggedUser?>> signup(EmailCredencials credencials);
}

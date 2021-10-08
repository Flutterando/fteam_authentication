import 'package:dartz/dartz.dart';

import '../entities/logged_user.dart';
import '../errors/errors.dart';
import '../models/email_credencials.dart';
import '../repositories/signup_with_email_repository.dart';

abstract class SignupWithEmail {
  Future<Either<AuthFailure, LoggedUser?>> call(
      {required EmailCredencials credencials});
}

class SignupWithEmailImpl implements SignupWithEmail {
  final SignupWithEmailRepository repository;

  const SignupWithEmailImpl({required this.repository});

  @override
  Future<Either<AuthFailure, LoggedUser?>> call(
      {required EmailCredencials credencials}) async {
    return await repository.signup(credencials);
  }
}

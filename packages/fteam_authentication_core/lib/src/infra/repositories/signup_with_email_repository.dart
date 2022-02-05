import 'package:dartz/dartz.dart';

import '../../domain/entities/logged_user.dart';
import '../../domain/errors/errors.dart';
import '../../domain/models/email_credencials.dart';
import '../../domain/repositories/signup_with_email_repository.dart';
import '../datasource/auth_datasource.dart';

class SignupWithEmailRepositoryImpl implements SignupWithEmailRepository {
  final AuthDatasource datasource;

  const SignupWithEmailRepositoryImpl({required this.datasource});

  @override
  Future<Either<AuthFailure, LoggedUser?>> signup(
      EmailCredencials credencials) async {
    try {
      final user = await datasource.signupWithEmail(credencials);
      return Right(user);
    } catch (e, st) {
      return Left(EmailLoginError(
          message: 'signupWithEmailRepositoryImpl.errorMessage',
          mainException: e,
          stacktrace: st));
    }
  }
}

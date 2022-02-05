import 'dart:async';

import 'package:dartz/dartz.dart';

import '../entities/logged_user.dart';
import '../errors/errors.dart';
import '../models/email_credencials.dart';
import '../repositories/auth_repository.dart';

abstract class Login {
  Future<Either<AuthFailure, LoggedUser?>> call(
      {required ProviderLogin provider, EmailCredencials? credencials});
}

class LoginImpl implements Login {
  final AuthRepository repository;

  const LoginImpl({required this.repository});

  @override
  Future<Either<AuthFailure, LoggedUser?>> call(
      {required ProviderLogin provider, EmailCredencials? credencials}) async {
    switch (provider) {
      case ProviderLogin.google:
        return await repository.googleLogin();
      case ProviderLogin.appleId:
        return await repository.appleIdLogin();
      case ProviderLogin.facebook:
        return await repository.facebookLogin();
      case ProviderLogin.emailSignin:
        assert(
            provider == ProviderLogin.emailSignin ? credencials != null : true,
            'Provider.emailSignin needs credencials');
        return await repository.emailLogin(credencials!);
      default:
        return Right(null);
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

import '../../domain/entities/logged_user.dart';
import '../../domain/errors/errors.dart';
import '../../domain/models/email_credencials.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasource/auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource datasource;

  const AuthRepositoryImpl({required this.datasource});

  Future<Either<AuthFailure, LoggedUser?>> _execute<T extends AuthFailure>(
      Future<LoggedUser?> Function() fuctionLoginFuture, T error) async {
    try {
      final user = await fuctionLoginFuture();
      if (user == null) return Right(null);
      return Right(user);
    } on AuthFailure catch (ex) {
      return Left(ex);
    } on PlatformException catch (ex, st) {
      if (ex.code == 'account-exists-with-different-credential') {
        return Left(DuplicatedAccountProviderError(
            message: 'AuthRepositoryImpl.DuplicatedAccountProviderError',
            mainException: ex,
            stacktrace: st));
      }
      return Left(error.copyWith(mainException: ex, stacktrace: st));
    } on Exception catch (ex, st) {
      if (ex.toString().contains('account-exists-with-different-credential')) {
        return Left(DuplicatedAccountProviderError(
            message: 'AuthRepositoryImpl.DuplicatedAccountProviderError',
            mainException: ex,
            stacktrace: st));
      }
      return Left(error.copyWith(mainException: ex, stacktrace: st));
    }
  }

  @override
  Future<Either<AuthFailure, LoggedUser?>> facebookLogin() {
    return _execute(
      datasource.loginWithFacebook,
      FacebookLoginError(message: 'auth.facebookLoginInternalError'),
    );
  }

  @override
  Future<Either<AuthFailure, LoggedUser?>> googleLogin() {
    return _execute(
      datasource.loginWithGoogle,
      GoogleLoginError(message: 'auth.googleLoginInternalError'),
    );
  }

  @override
  Future<Either<AuthFailure, LoggedUser?>> appleIdLogin() {
    return _execute(
      datasource.loginWithAppleId,
      AppleIdLoginError(message: 'auth.appleLoginInternalError'),
    );
  }

  @override
  Future<Either<AuthFailure, LoggedUser?>> emailLogin(
      EmailCredencials credencials) {
    return _execute(
      () => datasource.loginWithEmail(credencials),
      EmailLoginError(message: 'auth.emailLoginInternalError'),
    );
  }

  @override
  Future<Either<AuthFailure, Unit>> sendEmailVerification() async {
    try {
      await datasource.sendEmailVerification();
      return Right(unit);
    } catch (e, st) {
      return Left(EmailLoginError(
          message: 'auth.sendEmailVerification',
          mainException: e,
          stacktrace: st));
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> recoveryPassword(String email) async {
    try {
      await datasource.recoveryPassword(email);
      return Right(unit);
    } catch (e, st) {
      return Left(EmailLoginError(
          message: 'auth.recoveryPassword', mainException: e, stacktrace: st));
    }
  }
}

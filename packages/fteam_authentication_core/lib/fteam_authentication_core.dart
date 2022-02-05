library fteam_authentication_core;

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import 'src/core_module.dart';
import 'src/domain/entities/logged_user.dart';
import 'src/domain/errors/errors.dart';
import 'src/domain/models/email_credencials.dart';
import 'src/domain/usecases/delete_account.dart';
import 'src/domain/usecases/get_logged_user.dart';
import 'src/domain/usecases/link_account.dart';
import 'src/domain/usecases/login.dart';
import 'src/domain/usecases/logout.dart';
import 'src/domain/usecases/recovery_password.dart';
import 'src/domain/usecases/send_email_verification.dart';
import 'src/domain/usecases/signup_with_email.dart';
import 'src/domain/usecases/unlink_account.dart';
import 'src/infra/datasource/auth_datasource.dart';
import 'src/interfaces/fteam_authetication.dart';

export 'src/domain/entities/logged_user.dart';
export 'src/domain/errors/errors.dart';
export 'src/domain/models/email_credencials.dart';
export 'src/infra/datasource/auth_datasource.dart';

// ignore: non_constant_identifier_names
final FTeamAuth = _FteamAutheticationImpl();

class _FteamAutheticationImpl implements FteamAuthetication {
  @override
  Future<Either<AuthFailure, Unit>> deleteAccount() {
    return authModule.resolve<DeleteAccount>()();
  }

  @override
  Future<Either<AuthFailure, LoggedUser?>> getLoggedUser({
    bool Function(String token, Map payload)? checkToken,
    Duration tryAgainTime = const Duration(milliseconds: 800),
  }) {
    return authModule.resolve<GetLoggedUser>().call(
        checkToken: checkToken as bool Function(String, Map<dynamic, dynamic>),
        tryAgainTime: tryAgainTime);
  }

  @override
  Future<Either<AuthFailure, LoggedUser?>> linkAccount(ProviderLogin provider) {
    return authModule.resolve<LinkAccount>()(provider);
  }

  @override
  Future<Either<AuthFailure, LoggedUser?>> login(ProviderLogin provider,
      {EmailCredencials? credencials}) {
    return authModule.resolve<Login>()(
        provider: provider, credencials: credencials);
  }

  @override
  Future<Either<LogoutFailure, Unit>> logout() {
    return authModule.resolve<Logout>()();
  }

  @override
  Future<Either<AuthFailure, LoggedUser?>> unLinkAccount(
      ProviderLogin provider) {
    return authModule.resolve<UnLinkAccount>()(provider);
  }

  @override
  void registerAuthDatasource(AuthDatasource instance) {
    authModule.registerInstance<AuthDatasource>(instance);
  }

  @visibleForTesting
  @override
  void changeRegister<T>(T instance) {
    authModule.unregister<T>();
    authModule.registerInstance<T>(instance);
  }

  @override
  Future<Either<AuthFailure, Unit>> sendEmailVerification() {
    return authModule.resolve<SendEmailVerification>()();
  }

  @override
  Future<Either<AuthFailure, LoggedUser?>> signupWithEmail(
      {@required EmailCredencials? credencials}) {
    return authModule.resolve<SignupWithEmail>()(
        credencials: credencials as EmailCredencials);
  }

  @override
  Future<Either<AuthFailure, Unit>> recoveryPassword(String email) {
    return authModule.resolve<RecoveryPassword>()(email);
  }
}

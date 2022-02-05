import 'package:kiwi/kiwi.dart';

import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/delete_account_repository.dart';
import 'domain/repositories/link_account_repository.dart';
import 'domain/repositories/logout_repository.dart';
import 'domain/repositories/signup_with_email_repository.dart';
import 'domain/services/get_logged_user_service.dart';
import 'domain/usecases/delete_account.dart';
import 'domain/usecases/get_logged_user.dart';
import 'domain/usecases/link_account.dart';
import 'domain/usecases/login.dart';
import 'domain/usecases/logout.dart';
import 'domain/usecases/recovery_password.dart';
import 'domain/usecases/send_email_verification.dart';
import 'domain/usecases/signup_with_email.dart';
import 'domain/usecases/unlink_account.dart';
import 'infra/repositories/auth_repository.dart';
import 'infra/repositories/delete_account_repository.dart';
import 'infra/repositories/link_account_repository.dart';
import 'infra/repositories/logout_repository.dart';
import 'infra/repositories/signup_with_email_repository.dart';
import 'infra/services/get_logged_user_service.dart';

final authModule = KiwiContainer.scoped()
  //usecases
  ..registerFactory<DeleteAccount>((c) => DeleteAccountImpl(repository: c()))
  ..registerFactory<GetLoggedUser>((c) => GetLoggedUserImpl(service: c()))
  ..registerFactory<LinkAccount>((c) => LinkAccountImpl(repository: c()))
  ..registerFactory<Login>((c) => LoginImpl(repository: c()))
  ..registerFactory<Logout>((c) => LogoutImpl(repository: c()))
  ..registerFactory<UnLinkAccount>((c) => UnLinkAccountImpl(repository: c()))
  ..registerFactory<SendEmailVerification>(
      (c) => SendEmailVerificationImpl(repository: c()))
  ..registerFactory<SignupWithEmail>(
      (c) => SignupWithEmailImpl(repository: c()))
  ..registerFactory<RecoveryPassword>(
      (c) => RecoveryPasswordImpl(repository: c()))
  //infra
  ..registerFactory<GetLoggedUserService>(
      (c) => GetLoggedUserServiceImpl(datasource: c()))
  ..registerFactory<AuthRepository>((c) => AuthRepositoryImpl(datasource: c()))
  ..registerFactory<DeleteAccountRepository>(
      (c) => DeleteAccountRepositoryImpl(datasource: c()))
  ..registerFactory<LinkAccountRepository>(
      (c) => LinkAccountRepositoryImpl(datasource: c()))
  ..registerFactory<LogoutRepository>(
      (c) => LogoutRepositoryImpl(datasource: c()))
  ..registerFactory<SignupWithEmailRepository>(
      (c) => SignupWithEmailRepositoryImpl(datasource: c()));

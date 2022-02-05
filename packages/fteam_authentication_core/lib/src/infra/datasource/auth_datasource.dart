import 'dart:async';

import '../../domain/entities/logged_user.dart';
import '../../domain/models/email_credencials.dart';

abstract class AuthDatasource {
  Future<LoggedUser?> loginWithGoogle();
  Future<LoggedUser?> loginWithFacebook();
  Future<LoggedUser?> loginWithAppleId();
  Future<LoggedUser?> loginWithEmail(EmailCredencials credencials);
  Future<LoggedUser?> signupWithEmail(EmailCredencials credencials);
  Future<int> logout();
  Future<void> deleteAccount();
  Future<void> sendEmailVerification();
  Future<void> recoveryPassword(String email);
  Future<LoggedUser?> getLoggedUser();
  FutureOr<LoggedUser?> linkAccount(ProviderLogin provider);
  Future<LoggedUser?> unlinkAccount(ProviderLogin provider);
}

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fteam_authentication_core/fteam_authentication_core.dart';
import 'package:fteam_authentication_core/src/domain/models/email_credencials.dart';
import 'package:fteam_authentication_core/src/infra/datasource/auth_datasource.dart';
import 'package:fteam_authentication_core/src/infra/repositories/auth_repository.dart';
import 'package:mocktail/mocktail.dart';

class AuthDatasourceMock extends Mock implements AuthDatasource {}

void main() {
  final datasourceMock = AuthDatasourceMock();
  final repository = AuthRepositoryImpl(datasource: datasourceMock);

  setUpAll(() {
    registerFallbackValue(EmailCredencials(email: '', password: ''));
  });

  group('Google', () {
    test('should do login', () async {
      final user =
          LoggedUser(providers: [ProviderLogin.google], token: '', uid: '');
      when(() => datasourceMock.loginWithGoogle())
          .thenAnswer((_) async => user);
      final result = await repository.googleLogin();
      expect(result.fold(id, id), user);
    });
    test('should throw exception on internal failure login', () async {
      when(() => datasourceMock.loginWithGoogle()).thenThrow(Exception());
      final result = await repository.googleLogin();
      expect(result.fold(id, id), isA<GoogleLoginError>());
    });
    test(
        'should throw PlatformException on PlatformException with code account-exists-with-different-credential',
        () async {
      when(() => datasourceMock.loginWithGoogle()).thenThrow(
          PlatformException(code: 'account-exists-with-different-credential'));
      final result = await repository.googleLogin();
      expect(result.fold(id, id), isA<DuplicatedAccountProviderError>());
    });
  });

  group('Facebook', () {
    test('should do login', () async {
      final user =
          LoggedUser(providers: [ProviderLogin.google], token: '', uid: '');
      when(() => datasourceMock.loginWithFacebook())
          .thenAnswer((_) async => user);
      final result = await repository.facebookLogin();
      expect(result.fold(id, id), user);
    });
    test('should throw exception on internal failure login', () async {
      when(() => datasourceMock.loginWithFacebook()).thenThrow(Exception());
      final result = await repository.facebookLogin();
      expect(result.fold(id, id), isA<FacebookLoginError>());
    });
  });
  group('AppleId', () {
    test('should do login', () async {
      final user =
          LoggedUser(providers: [ProviderLogin.google], token: '', uid: '');
      when(() => datasourceMock.loginWithAppleId())
          .thenAnswer((_) async => user);
      final result = await repository.appleIdLogin();
      expect(result.fold(id, id), user);
    });
    test('should throw exception on internal failure login', () async {
      when(() => datasourceMock.loginWithAppleId()).thenThrow(Exception());
      final result = await repository.appleIdLogin();
      expect(result.fold(id, id), isA<AppleIdLoginError>());
    });
  });
  group('Email', () {
    test('should do login', () async {
      final user =
          LoggedUser(providers: [ProviderLogin.google], token: '', uid: '');
      when(() => datasourceMock.loginWithEmail(any()))
          .thenAnswer((_) async => user);
      final result = await repository
          .emailLogin(EmailCredencials(email: '', password: ''));
      expect(result.fold(id, id), user);
    });
    test('should throw exception on internal failure login', () async {
      when(() => datasourceMock.loginWithEmail(any())).thenThrow(Exception());
      final result = await repository
          .emailLogin(EmailCredencials(email: '', password: ''));
      expect(result.fold(id, id), isA<EmailLoginError>());
    });
  });
}

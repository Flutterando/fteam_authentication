import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fteam_authentication_core/fteam_authentication_core.dart';
import 'package:fteam_authentication_core/src/domain/models/email_credencials.dart';
import 'package:fteam_authentication_core/src/infra/datasource/auth_datasource.dart';
import 'package:fteam_authentication_core/src/infra/repositories/signup_with_email_repository.dart';
import 'package:mocktail/mocktail.dart';

class AuthDatasourceMock extends Mock implements AuthDatasource {}

void main() {
  final datasourceMock = AuthDatasourceMock();
  final repository = SignupWithEmailRepositoryImpl(datasource: datasourceMock);

  setUpAll(() {
    registerFallbackValue(EmailCredencials(email: 'null', password: 'null'));
  });

  test('should do signup', () async {
    when(() => datasourceMock.signupWithEmail(any())).thenAnswer((_) async =>
        LoggedUser(providers: [ProviderLogin.google], token: '', uid: ''));
    final result = await repository
        .signup(EmailCredencials(email: 'null', password: 'null'));
    expect(result.fold(id, id), isA<LoggedUser>());
  });
}

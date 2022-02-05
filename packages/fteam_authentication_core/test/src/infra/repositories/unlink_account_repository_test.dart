import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fteam_authentication_core/fteam_authentication_core.dart';
import 'package:fteam_authentication_core/src/infra/repositories/link_account_repository.dart';
import 'package:mocktail/mocktail.dart';

class AuthDatasourceMock extends Mock implements AuthDatasource {}

void main() {
  final datasourceMock = AuthDatasourceMock();
  final repository = LinkAccountRepositoryImpl(datasource: datasourceMock);

  test('should do unlink account', () async {
    when(() => datasourceMock.unlinkAccount(ProviderLogin.google)).thenAnswer(
        (_) async =>
            LoggedUser(providers: [ProviderLogin.google], token: '', uid: ''));
    final result = await repository.unlinkAccount(ProviderLogin.google);
    expect(result.fold(id, id), isA<LoggedUser>());
  });

  test('should throw AuthFailure file', () async {
    when(() => datasourceMock.unlinkAccount(ProviderLogin.google))
        .thenThrow(CredentialsError(message: 'Test'));
    final result = await repository.unlinkAccount(ProviderLogin.google);
    expect(result.fold(id, id), isA<CredentialsError>());
  });

  test('should throw unknown error return LinkAccountError', () async {
    when(() => datasourceMock.unlinkAccount(ProviderLogin.google))
        .thenThrow(Exception());
    final result = await repository.unlinkAccount(ProviderLogin.google);
    expect(result.fold(id, id), isA<LinkAccountError>());
  });
}

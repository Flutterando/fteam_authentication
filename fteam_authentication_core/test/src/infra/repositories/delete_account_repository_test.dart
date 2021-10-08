import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fteam_authentication_core/src/infra/datasource/auth_datasource.dart';
import 'package:fteam_authentication_core/src/infra/repositories/delete_account_repository.dart';
import 'package:mocktail/mocktail.dart';

class AuthDatasourceMock extends Mock implements AuthDatasource {}

void main() {
  final datasourceMock = AuthDatasourceMock();
  final repository = DeleteAccountRepositoryImpl(datasource: datasourceMock);

  test('should delete account', () async {
    when(() => datasourceMock.deleteAccount()).thenAnswer((_) async => 0);
    final result = await repository.delete();
    expect(result.fold(id, id), unit);
  });
}

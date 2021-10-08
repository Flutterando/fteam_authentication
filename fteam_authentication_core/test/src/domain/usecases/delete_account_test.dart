import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fteam_authentication_core/src/domain/repositories/delete_account_repository.dart';
import 'package:fteam_authentication_core/src/domain/usecases/delete_account.dart';
import 'package:mocktail/mocktail.dart';

class DeleteAccountRepositoryMock extends Mock
    implements DeleteAccountRepository {}

void main() {
  late DeleteAccountRepository repository;
  late DeleteAccount usecase;
  setUpAll(() {
    repository = DeleteAccountRepositoryMock();
    usecase = DeleteAccountImpl(repository: repository);
  });

  test('should delete account', () async {
    when(() => repository.delete()).thenAnswer((_) async => const Right(unit));
    final result = await usecase();

    expect(result.fold(id, id), unit);
  });
}

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fteam_authentication_core/fteam_authentication_core.dart';
import 'package:fteam_authentication_core/src/domain/repositories/link_account_repository.dart';
import 'package:fteam_authentication_core/src/domain/usecases/link_account.dart';
import 'package:mocktail/mocktail.dart';

class LinkAccountRepositoryMock extends Mock implements LinkAccountRepository {}

void main() {
  late LinkAccountRepository repository;
  late LinkAccount usecase;
  setUpAll(() {
    repository = LinkAccountRepositoryMock();
    usecase = LinkAccountImpl(repository: repository);
  });

  test('should do link account', () async {
    when(() => repository.linkAccount(ProviderLogin.google)).thenAnswer(
        (_) async => const Right(
            LoggedUser(providers: [ProviderLogin.google], token: '', uid: '')));
    final result = await usecase(ProviderLogin.google);
    expect(result.fold(id, id), isA<LoggedUser>());
  });
}

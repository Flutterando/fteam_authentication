import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fteam_authentication_core/fteam_authentication_core.dart';
import 'package:fteam_authentication_core/src/domain/repositories/link_account_repository.dart';
import 'package:fteam_authentication_core/src/domain/usecases/unlink_account.dart';
import 'package:mocktail/mocktail.dart';

class LinkAccountRepositoryMock extends Mock implements LinkAccountRepository {}

void main() {
  late LinkAccountRepository repository;
  late UnLinkAccount usecase;
  setUpAll(() {
    repository = LinkAccountRepositoryMock();
    usecase = UnLinkAccountImpl(repository: repository);
  });

  test('should do unlink account', () async {
    when(() => repository.unlinkAccount(ProviderLogin.google)).thenAnswer(
        (_) async => const Right(
            LoggedUser(providers: [ProviderLogin.google], token: '', uid: '')));
    final result = await usecase(ProviderLogin.google);
    expect(result.fold(id, id), isA<LoggedUser>());
  });
}

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fteam_authentication_core/fteam_authentication_core.dart';
import 'package:fteam_authentication_core/src/domain/repositories/auth_repository.dart';
import 'package:fteam_authentication_core/src/domain/usecases/login.dart';
import 'package:mocktail/mocktail.dart';

class LoginRepositoryMock extends Mock implements AuthRepository {}

void main() {
  late AuthRepository repository;
  late Login usecase;
  setUpAll(() {
    repository = LoginRepositoryMock();
    usecase = LoginImpl(repository: repository);
    registerFallbackValue(EmailCredencials(email: 'null', password: 'null'));
  });

  test('should do login with Email provider', () async {
    const user =
        LoggedUser(providers: [ProviderLogin.google], token: '', uid: '');
    when(() => repository.emailLogin(any()))
        .thenAnswer((_) async => const Right(user));
    final result = await usecase(
        provider: ProviderLogin.emailSignin,
        credencials: EmailCredencials(email: 'null', password: 'null'));
    verify(() => repository.emailLogin(any())).called(1);

    expect(result.fold(id, id), user);
  });

  test('throw assert error when credencials is null with Email provider',
      () async {
    const user =
        LoggedUser(providers: [ProviderLogin.google], token: '', uid: '');
    when(() => repository.emailLogin(any()))
        .thenAnswer((_) async => const Right(user));

    expect(() async => await usecase(provider: ProviderLogin.emailSignin),
        throwsAssertionError);
  });

  test('should do login with google provider', () async {
    const user =
        LoggedUser(providers: [ProviderLogin.google], token: '', uid: '');
    when(() => repository.googleLogin())
        .thenAnswer((_) async => const Right(user));
    final result = await usecase(provider: ProviderLogin.google);
    verify(() => repository.googleLogin()).called(1);

    expect(result.fold(id, id), user);
  });
  test('should do login with facebook provider', () async {
    const user =
        LoggedUser(providers: [ProviderLogin.google], token: '', uid: '');
    when(() => repository.facebookLogin())
        .thenAnswer((_) async => const Right(user));
    final result = await usecase(provider: ProviderLogin.facebook);
    verify(() => repository.facebookLogin()).called(1);
    expect(result.fold(id, id), user);
  });
  test('should do login with appleId provider', () async {
    const user =
        LoggedUser(providers: [ProviderLogin.google], token: '', uid: '');
    when(() => repository.appleIdLogin())
        .thenAnswer((_) async => const Right(user));
    final result = await usecase(provider: ProviderLogin.appleId);
    verify(() => repository.appleIdLogin()).called(1);

    expect(result.fold(id, id), user);
  });
}

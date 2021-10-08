import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fteam_authentication_core/fteam_authentication_core.dart';
import 'package:fteam_authentication_core/src/domain/models/email_credencials.dart';
import 'package:fteam_authentication_core/src/domain/repositories/signup_with_email_repository.dart';
import 'package:fteam_authentication_core/src/domain/usecases/signup_with_email.dart';
import 'package:mocktail/mocktail.dart';

class SignupWithEmailRepositoryMock extends Mock
    implements SignupWithEmailRepository {}

void main() {
  late SignupWithEmailRepository repository;
  late SignupWithEmail usecase;
  setUpAll(() {
    repository = SignupWithEmailRepositoryMock();
    usecase = SignupWithEmailImpl(repository: repository);
    registerFallbackValue(EmailCredencials(email: 'null', password: 'null'));
  });

  test('should do signup with Email', () async {
    const user =
        LoggedUser(providers: [ProviderLogin.google], token: '', uid: '');
    when(() => repository.signup(any()))
        .thenAnswer((_) async => const Right(user));
    final result = await usecase(
        credencials: EmailCredencials(email: 'null', password: 'null'));
    verify(() => repository.signup(any())).called(1);
    expect(result.fold(id, id), user);
  });
}

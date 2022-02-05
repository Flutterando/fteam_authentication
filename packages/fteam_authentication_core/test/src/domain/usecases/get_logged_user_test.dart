import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fteam_authentication_core/fteam_authentication_core.dart';
import 'package:fteam_authentication_core/src/domain/services/get_logged_user_service.dart';
import 'package:fteam_authentication_core/src/domain/usecases/get_logged_user.dart';
import 'package:mocktail/mocktail.dart';

class GetLoggedUserServiceMock extends Mock implements GetLoggedUserService {}

void main() {
  late GetLoggedUserService service;
  late GetLoggedUser usecase;
  setUpAll(() {
    service = GetLoggedUserServiceMock();
    usecase = GetLoggedUserImpl(service: service);
  });

  test('should get LoggedUser object Right result', () async {
    const user =
        LoggedUser(providers: [ProviderLogin.google], token: '', uid: '');
    when(() => service.getUser()).thenAnswer((_) async => const Right(user));
    final result = await usecase();
    expect(result, const Right(user));
  });
  test('should throw exception and return a AuthFailure', () async {
    when(() => service.getUser())
        .thenAnswer((_) async => const Left(NotUserLogged(message: '')));
    final result = await usecase();
    // ignore: inference_failure_on_instance_creation
    expect(result, const Left(NotUserLogged(message: '')));
  });

  test('should get LoggedUser object', () async {
    const user = LoggedUser(
        providers: [ProviderLogin.google], token: tokenTest, uid: '');
    when(() => service.getUser()).thenAnswer((_) async => const Right(user));
    var counter = 0;
    final result = await usecase.call(
      checkToken: (token, payload) {
        counter++;
        return counter > 3;
      },
    );
    expect(result.isRight(), true);
    var response = result.fold(id, id);
    expect(response, isA<LoggedUser>());
  });
}

const tokenTest =
    'eyJhbGciOiJSUzI1NiIsImtpZCI6IjlhZDBjYjdjMGY1NTkwMmY5N2RjNTI0NWE4ZTc5NzFmMThkOWM3NjYiLCJ0eXAiOiJKV1QifQ.eyJuYW1lIjoiVGVjTGVpZ28gTW91cmEiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EtL0FPaDE0R2hocG53WWFtMWdCcGFZWFlpZlAtaWpnVm5tU3JINzNUWTdXbFk4PXM5Ni1jIiwiVm9sdW50ZWVycyI6ZmFsc2UsIkFkbWluIjpmYWxzZSwiQmVuZWZpY2lhcnkiOnRydWUsImlzcyI6Imh0dHBzOi8vc2VjdXJldG9rZW4uZ29vZ2xlLmNvbS9hZHJhLWJlbmVmaWNpYXJpZXMtaG8iLCJhdWQiOiJhZHJhLWJlbmVmaWNpYXJpZXMtaG8iLCJhdXRoX3RpbWUiOjE2MDYzOTMwMDIsInVzZXJfaWQiOiJuYnpBN0RLQWt0WHJWWFlRWG5xcnNHOWVYckkzIiwic3ViIjoibmJ6QTdES0FrdFhyVlhZUVhucXJzRzllWHJJMyIsImlhdCI6MTYwNjQwMTUwNSwiZXhwIjoxNjA2NDA1MTA1LCJlbWFpbCI6InRlY2xlaWdvQGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7Imdvb2dsZS5jb20iOlsiMTAzNzc3NjEyNDMxMTIzMTk2NDgxIl0sImFwcGxlLmNvbSI6WyIwMDAwMjcuOWNiMzJlYTg4N2NlNGM3NzhmYTcwMDFjOWMyYTMxYjcuMTIwMSJdLCJlbWFpbCI6WyJ0ZWNsZWlnb0BnbWFpbC5jb20iXX0sInNpZ25faW5fcHJvdmlkZXIiOiJnb29nbGUuY29tIn19.ewGRVUxFAGgt3tKb7dbNlpIuaIprJCwhegC54LlcaqFbqmtg87hztGdqmbmD3SeQRXYbj08okGTuz-pnwHIYMQOaVUT2MKddqysFg4EzIfSR1Sh61zrvjr5BwGtQD6xrCDW1FlgI2tCFOCZcBbfzfAv4cqXbYx1fWCjL8f-qDnXqMNtj-3tG6HkjIesGkwsSY8cEKV525KX-6twhNMmgra3kDGMpwg34fIcMfXMLxedJ_bWqTnTpqVBv2_UMyb__WPbsTYDi86o5-UFiVoz6wj3L_sV1PNxZZtIKg33dIXDUGxM3U12j9lHwkMrS8LGcRlqyDfYRybtsa9aeHsj25w';

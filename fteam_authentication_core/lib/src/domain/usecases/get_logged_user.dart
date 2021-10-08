import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../entities/logged_user.dart';
import '../errors/errors.dart';
import '../services/get_logged_user_service.dart';

abstract class GetLoggedUser {
  ///[checkToken] return true if token is valid
  ///when token is invalid, will try again.
  ///[tryAgainTime] defaul is 800 miliseconds.
  Future<Either<AuthFailure, LoggedUser?>> call(
      {bool Function(String token, Map payload) checkToken,
      Duration tryAgainTime = const Duration(milliseconds: 800)});
}

class GetLoggedUserImpl implements GetLoggedUser {
  final GetLoggedUserService service;

  const GetLoggedUserImpl({required this.service});

  @override
  Future<Either<AuthFailure, LoggedUser?>> call({
    bool Function(String token, Map payload)? checkToken,
    Duration tryAgainTime = const Duration(milliseconds: 800),
  }) async {
    if (checkToken == null) {
      return await service.getUser();
    }

    while (true) {
      final result = await service.getUser();
      if (result.isLeft()) {
        return result;
      }
      final user = result.fold((l) => null, id);

      if (user == null) {
        return Left(NotUserLogged());
      }
      final payload = JwtDecoder.decode(user.token);
      if (!checkToken(user.token, payload)) {
        debugPrint('invalid token: try again...');
        await Future.delayed(tryAgainTime);
        continue;
      }
      return result;
    }
  }
}

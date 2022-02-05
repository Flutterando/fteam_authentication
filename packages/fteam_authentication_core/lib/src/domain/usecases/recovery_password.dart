import 'package:dartz/dartz.dart';

import '../errors/errors.dart';
import '../repositories/auth_repository.dart';

abstract class RecoveryPassword {
  Future<Either<AuthFailure, Unit>> call(String email);
}

class RecoveryPasswordImpl implements RecoveryPassword {
  final AuthRepository repository;

  const RecoveryPasswordImpl({required this.repository});

  @override
  Future<Either<AuthFailure, Unit>> call(String email) async {
    return await repository.recoveryPassword(email);
  }
}

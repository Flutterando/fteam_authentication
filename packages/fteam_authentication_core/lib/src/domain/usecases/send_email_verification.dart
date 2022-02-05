import 'package:dartz/dartz.dart';

import '../errors/errors.dart';
import '../repositories/auth_repository.dart';

abstract class SendEmailVerification {
  Future<Either<AuthFailure, Unit>> call();
}

class SendEmailVerificationImpl implements SendEmailVerification {
  final AuthRepository repository;

  const SendEmailVerificationImpl({required this.repository});

  @override
  Future<Either<AuthFailure, Unit>> call() async {
    return await repository.sendEmailVerification();
  }
}

import 'package:dartz/dartz.dart';

import '../errors/errors.dart';
import '../repositories/delete_account_repository.dart';

abstract class DeleteAccount {
  Future<Either<AuthFailure, Unit>> call();
}

class DeleteAccountImpl implements DeleteAccount {
  final DeleteAccountRepository repository;

  const DeleteAccountImpl({required this.repository});

  @override
  Future<Either<AuthFailure, Unit>> call() async {
    return await repository.delete();
  }
}

import 'package:dartz/dartz.dart';

import '../../domain/errors/errors.dart';
import '../../domain/repositories/delete_account_repository.dart';
import '../datasource/auth_datasource.dart';

class DeleteAccountRepositoryImpl implements DeleteAccountRepository {
  final AuthDatasource datasource;

  const DeleteAccountRepositoryImpl({required this.datasource});

  @override
  Future<Either<AuthFailure, Unit>> delete() async {
    try {
      await datasource.deleteAccount();
      return Right(unit);
    } on AuthFailure catch (e) {
      return Left(e);
    }
  }
}

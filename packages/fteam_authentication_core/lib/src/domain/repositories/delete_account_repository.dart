import 'package:dartz/dartz.dart';

import '../errors/errors.dart';

abstract class DeleteAccountRepository {
  Future<Either<AuthFailure, Unit>> delete();
}

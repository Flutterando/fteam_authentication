import 'package:dartz/dartz.dart';

import '../entities/logged_user.dart';
import '../errors/errors.dart';

abstract class LinkAccountRepository {
  Future<Either<AuthFailure, LoggedUser?>> linkAccount(ProviderLogin provider);
  Future<Either<AuthFailure, LoggedUser?>> unlinkAccount(
      ProviderLogin provider);
}

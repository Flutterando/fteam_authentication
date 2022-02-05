import 'package:dartz/dartz.dart';

import '../entities/logged_user.dart';
import '../errors/errors.dart';
import '../repositories/link_account_repository.dart';

abstract class UnLinkAccount {
  Future<Either<AuthFailure, LoggedUser?>> call(ProviderLogin provider);
}

class UnLinkAccountImpl implements UnLinkAccount {
  final LinkAccountRepository repository;

  const UnLinkAccountImpl({required this.repository});

  @override
  Future<Either<AuthFailure, LoggedUser?>> call(ProviderLogin provider) async {
    return await repository.unlinkAccount(provider);
  }
}

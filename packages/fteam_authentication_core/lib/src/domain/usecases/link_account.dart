import 'package:dartz/dartz.dart';

import '../entities/logged_user.dart';
import '../errors/errors.dart';
import '../repositories/link_account_repository.dart';

abstract class LinkAccount {
  Future<Either<AuthFailure, LoggedUser?>> call(ProviderLogin provider);
}

class LinkAccountImpl implements LinkAccount {
  final LinkAccountRepository repository;

  const LinkAccountImpl({required this.repository});

  @override
  Future<Either<AuthFailure, LoggedUser?>> call(ProviderLogin provider) async {
    return await repository.linkAccount(provider);
  }
}

import 'package:dartz/dartz.dart';
import '../../domain/entities/logged_user.dart';
import '../../domain/errors/errors.dart';
import '../../domain/repositories/link_account_repository.dart';
import '../datasource/auth_datasource.dart';

class LinkAccountRepositoryImpl implements LinkAccountRepository {
  final AuthDatasource datasource;

  LinkAccountRepositoryImpl({required this.datasource});

  @override
  Future<Either<AuthFailure, LoggedUser?>> linkAccount(
      ProviderLogin provider) async {
    try {
      final result = await datasource.linkAccount(provider);
      return Right(result);
    } on AuthFailure catch (e) {
      return Left(e);
    } catch (e, st) {
      return Left(LinkAccountError(
          message: e.toString(), mainException: e, stacktrace: st));
    }
  }

  @override
  Future<Either<AuthFailure, LoggedUser?>> unlinkAccount(
      ProviderLogin provider) async {
    try {
      final result = await datasource.unlinkAccount(provider);
      return Right(result);
    } on AuthFailure catch (e) {
      return Left(e);
    } catch (e, st) {
      return Left(LinkAccountError(
          message: 'linkAccountRepositoryImpl.unlinkAcountError',
          mainException: e,
          stacktrace: st));
    }
  }
}

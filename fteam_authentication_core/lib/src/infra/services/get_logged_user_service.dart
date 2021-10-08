import 'package:dartz/dartz.dart';

import '../../domain/entities/logged_user.dart';
import '../../domain/errors/errors.dart';
import '../../domain/services/get_logged_user_service.dart';
import '../datasource/auth_datasource.dart';

class GetLoggedUserServiceImpl implements GetLoggedUserService {
  final AuthDatasource datasource;

  const GetLoggedUserServiceImpl({required this.datasource});
  @override
  Future<Either<AuthFailure, LoggedUser?>> getUser() async {
    try {
      final result = await datasource.getLoggedUser();
      // if (result == null) {
      //   return Left(NotUserLogged());
      // }
      return Right(result);
    } on AuthFailure catch (e) {
      return Left(e);
    } catch (e, st) {
      return Left(NotUserLogged(message: '', mainException: e, stacktrace: st));
    }
  }
}

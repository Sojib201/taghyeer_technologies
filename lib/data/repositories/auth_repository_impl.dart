import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../core/utils/either.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> login(
      String username, String password) async {
    if (!await networkInfo.isConnected) {
      return const Either.left(NetworkFailure());
    }
    try {
      final user = await remoteDataSource.login(username, password);
      await localDataSource.cacheUser(user);
      return Either.right(user);
    } on Failure catch (f) {
      return Either.left(f);
    } catch (_) {
      return const Either.left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCachedUser() async {
    try {
      final user = await localDataSource.getCachedUser();
      return Either.right(user);
    } on Failure catch (f) {
      return Either.left(f);
    } catch (_) {
      return const Either.left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearUser();
      return const Either.right(null);
    } on Failure catch (f) {
      return Either.left(f);
    } catch (_) {
      return const Either.left(CacheFailure());
    }
  }
}

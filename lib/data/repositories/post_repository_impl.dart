import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../core/utils/either.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_remote_datasource.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PostRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<PostEntity>>> getPosts({
    required int limit,
    required int skip,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Either.left(NetworkFailure());
    }
    try {
      final posts = await remoteDataSource.getPosts(limit: limit, skip: skip);
      return Either.right(posts);
    } on Failure catch (f) {
      return Either.left(f);
    } catch (_) {
      return const Either.left(UnknownFailure());
    }
  }
}

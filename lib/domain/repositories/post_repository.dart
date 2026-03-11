import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../entities/post_entity.dart';

abstract class PostRepository {
  Future<Either<Failure, List<PostEntity>>> getPosts({
    required int limit,
    required int skip,
  });
}

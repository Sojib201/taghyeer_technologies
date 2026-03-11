import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../core/utils/either.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    required int limit,
    required int skip,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Either.left(NetworkFailure());
    }
    try {
      final products = await remoteDataSource.getProducts(
        limit: limit,
        skip: skip,
      );
      return Either.right(products);
    } on Failure catch (f) {
      return Either.left(f);
    } catch (_) {
      return const Either.left(UnknownFailure());
    }
  }
}

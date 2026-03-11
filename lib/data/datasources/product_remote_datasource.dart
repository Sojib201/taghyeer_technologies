import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/failures.dart';
import '../../core/network/dio_client.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({required int limit, required int skip});
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final DioClient dioClient;

  ProductRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<ProductModel>> getProducts({
    required int limit,
    required int skip,
  }) async {
    try {
      final response = await dioClient.dio.get(
        AppConstants.productsEndpoint,
        queryParameters: {'limit': limit, 'skip': skip},
      );
      final List products = response.data['products'] ?? [];
      return products.map((p) => ProductModel.fromJson(p)).toList();
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw const UnknownFailure();
    }
  }
}

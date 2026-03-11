import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/failures.dart';
import '../../core/network/dio_client.dart';
import '../models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getPosts({required int limit, required int skip});
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final DioClient dioClient;

  PostRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<PostModel>> getPosts({
    required int limit,
    required int skip,
  }) async {
    try {
      final response = await dioClient.dio.get(
        AppConstants.postsEndpoint,
        queryParameters: {'limit': limit, 'skip': skip},
      );
      final List posts = response.data['posts'] ?? [];
      return posts.map((p) => PostModel.fromJson(p)).toList();
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw const UnknownFailure();
    }
  }
}

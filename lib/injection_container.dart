import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasources/auth_local_datasource.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/post_remote_datasource.dart';
import 'data/datasources/product_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/post_repository_impl.dart';
import 'data/repositories/product_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/post_repository.dart';
import 'domain/repositories/product_repository.dart';
import 'core/network/dio_client.dart';
import 'core/network/network_info.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/posts/posts_bloc.dart';
import 'presentation/blocs/products/products_bloc.dart';
import 'presentation/blocs/theme/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);
  sl.registerSingleton<Connectivity>(Connectivity());

  // Core
  sl.registerSingleton<DioClient>(DioClient());
  sl.registerSingleton<NetworkInfo>(NetworkInfo(sl<Connectivity>()));

  // Data Sources
  sl.registerSingleton<AuthRemoteDataSource>(
    AuthRemoteDataSourceImpl(sl<DioClient>()),
  );
  sl.registerSingleton<AuthLocalDataSource>(
    AuthLocalDataSourceImpl(sl<SharedPreferences>()),
  );
  sl.registerSingleton<ProductRemoteDataSource>(
    ProductRemoteDataSourceImpl(sl<DioClient>()),
  );
  sl.registerSingleton<PostRemoteDataSource>(
    PostRemoteDataSourceImpl(sl<DioClient>()),
  );

  // Repositories
  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );
  sl.registerSingleton<ProductRepository>(
    ProductRepositoryImpl(
      remoteDataSource: sl<ProductRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );
  sl.registerSingleton<PostRepository>(
    PostRepositoryImpl(
      remoteDataSource: sl<PostRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Blocs
  sl.registerFactory(() => AuthBloc(authRepository: sl<AuthRepository>()));
  sl.registerFactory(
    () => ProductsBloc(productRepository: sl<ProductRepository>()),
  );
  sl.registerFactory(() => PostsBloc(postRepository: sl<PostRepository>()));
  sl.registerSingleton<ThemeCubit>(
    ThemeCubit(sharedPreferences: sl<SharedPreferences>()),
  );
}

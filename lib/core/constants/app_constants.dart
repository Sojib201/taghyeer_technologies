class AppConstants {
  // API
  static const String baseUrl = 'https://dummyjson.com';
  static const String loginEndpoint = '/auth/login';
  static const String productsEndpoint = '/products';
  static const String postsEndpoint = '/posts';

  // Pagination
  static const int pageLimit = 10;

  // Keys
  static const String userKey = 'cached_user';
  static const String themeKey = 'theme_mode';
  static const String tokenKey = 'auth_token';

  // Timeouts
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
}

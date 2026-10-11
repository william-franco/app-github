class ApiConstant {
  static const String baseUrl = 'https://api.github.com';
  static const String searchRepositories = '/search/repositories';
  static String repository(String fullName) => '/repos/$fullName';

  static const String defaultQuery = 'stars:>1000';
  static const int perPage = 30;
  static const int maxResults = 1000;
}

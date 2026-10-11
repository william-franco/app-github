import 'package:app_github/src/common/enums/repositories_enums.dart';

class SearchParamsEntity {
  final String query;
  final String? language;
  final SortType sort;
  final OrderType order;
  final int page;

  const SearchParamsEntity({
    this.query = '',
    this.language,
    this.sort = SortType.bestMatch,
    this.order = OrderType.desc,
    this.page = 1,
  });

  SearchParamsEntity copyWith({
    String? query,
    String? Function()? language,
    SortType? sort,
    OrderType? order,
    int? page,
  }) {
    return SearchParamsEntity(
      query: query ?? this.query,
      language: language != null ? language() : this.language,
      sort: sort ?? this.sort,
      order: order ?? this.order,
      page: page ?? this.page,
    );
  }
}

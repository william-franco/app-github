import 'package:app_github/src/features/repositories/data/models/repository_model.dart';

class SearchResultModel {
  final int totalCount;
  final bool incompleteResults;
  final List<RepositoryModel> items;

  const SearchResultModel({
    required this.totalCount,
    required this.incompleteResults,
    required this.items,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      totalCount: json['total_count'] as int? ?? 0,
      incompleteResults: json['incomplete_results'] as bool? ?? false,
      items: (json['items'] as List? ?? const [])
          .map((item) => RepositoryModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

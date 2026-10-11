import 'package:mockito/mockito.dart';
import 'package:app_github/src/common/patterns/result_pattern.dart';
import 'package:app_github/src/features/repositories/data/data.dart';
import 'package:app_github/src/features/repositories/domain/domain.dart';

void registerDummies() {
  const error = RepositoryException('dummy');
  provideDummy<SearchResult>(const ErrorResult(error: error));
  provideDummy<RepositoryModelResult>(const ErrorResult(error: error));
  provideDummy<PageResult>(const ErrorResult(error: error));
  provideDummy<RepositoryResult>(const ErrorResult(error: error));
}

Map<String, dynamic> repositoryJson({int id = 1, String name = 'flutter'}) => {
  'id': id,
  'name': name,
  'full_name': 'flutter/$name',
  'description': 'Flutter makes it easy and fast to build apps.',
  'html_url': 'https://github.com/flutter/$name',
  'language': 'Dart',
  'stargazers_count': 170000,
  'forks_count': 28000,
  'watchers_count': 170000,
  'subscribers_count': 3500,
  'open_issues_count': 12000,
  'license': {'spdx_id': 'BSD-3-Clause', 'name': 'BSD 3-Clause'},
  'topics': ['dart', 'mobile'],
  'updated_at': '2026-10-01T10:00:00Z',
  'owner': {
    'login': 'flutter',
    'avatar_url': 'https://avatars.githubusercontent.com/u/14101776',
    'html_url': 'https://github.com/flutter',
  },
};

Map<String, dynamic> searchJson({int total = 2, int count = 2}) => {
  'total_count': total,
  'incomplete_results': false,
  'items': List.generate(count, (i) => repositoryJson(id: i, name: 'r$i')),
};

RepositoryEntity repositoryEntity({int id = 1}) =>
    RepositoryModel.fromJson(repositoryJson(id: id, name: 'r$id'));

PageEntity pageEntity({int page = 1, int count = 2, bool hasMore = true}) =>
    PageEntity(
      items: List.generate(count, (i) => repositoryEntity(id: page * 100 + i)),
      totalCount: 100,
      page: page,
      hasMore: hasMore,
    );

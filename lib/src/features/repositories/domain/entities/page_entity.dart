import 'package:app_github/src/features/repositories/domain/entities/repository_entity.dart';

class PageEntity {
  final List<RepositoryEntity> items;
  final int totalCount;
  final int page;
  final bool hasMore;

  const PageEntity({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.hasMore,
  });
}

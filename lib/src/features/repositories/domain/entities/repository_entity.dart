import 'package:app_github/src/features/repositories/domain/entities/owner_entity.dart';

class RepositoryEntity {
  final int id;
  final String name;
  final String fullName;
  final String? description;
  final String htmlUrl;
  final String? language;
  final int stars;
  final int forks;
  final int watchers;
  final int openIssues;
  final String? license;
  final List<String> topics;
  final DateTime? updatedAt;
  final OwnerEntity owner;

  const RepositoryEntity({
    required this.id,
    required this.name,
    required this.fullName,
    this.description,
    required this.htmlUrl,
    this.language,
    required this.stars,
    required this.forks,
    required this.watchers,
    required this.openIssues,
    this.license,
    this.topics = const [],
    this.updatedAt,
    required this.owner,
  });
}

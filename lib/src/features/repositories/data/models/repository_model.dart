import 'package:app_github/src/features/repositories/data/models/owner_model.dart';
import 'package:app_github/src/features/repositories/domain/entities/entities.dart';

class RepositoryModel extends RepositoryEntity {
  const RepositoryModel({
    required super.id,
    required super.name,
    required super.fullName,
    super.description,
    required super.htmlUrl,
    super.language,
    required super.stars,
    required super.forks,
    required super.watchers,
    required super.openIssues,
    super.license,
    super.topics,
    super.updatedAt,
    required super.owner,
  });

  factory RepositoryModel.fromJson(Map<String, dynamic> json) {
    final license = json['license'] as Map<String, dynamic>?;
    final updatedAt = json['updated_at'] as String?;

    return RepositoryModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      description: json['description'] as String?,
      htmlUrl: json['html_url'] as String? ?? '',
      language: json['language'] as String?,
      stars: json['stargazers_count'] as int? ?? 0,
      forks: json['forks_count'] as int? ?? 0,
      watchers:
          json['subscribers_count'] as int? ??
          json['watchers_count'] as int? ??
          0,
      openIssues: json['open_issues_count'] as int? ?? 0,
      license: _parseLicense(license),
      topics: List<String>.from(json['topics'] as List? ?? const []),
      updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt) : null,
      owner: OwnerModel.fromJson(
        json['owner'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }

  static String? _parseLicense(Map<String, dynamic>? license) {
    if (license == null) return null;
    final spdxId = license['spdx_id'] as String?;
    if (spdxId == null || spdxId == 'NOASSERTION') {
      return license['name'] as String?;
    }
    return spdxId;
  }
}

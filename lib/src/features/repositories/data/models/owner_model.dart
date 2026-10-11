import 'package:app_github/src/features/repositories/domain/entities/entities.dart';

class OwnerModel extends OwnerEntity {
  const OwnerModel({
    required super.login,
    required super.avatarUrl,
    required super.htmlUrl,
  });

  factory OwnerModel.fromJson(Map<String, dynamic> json) {
    return OwnerModel(
      login: json['login'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String? ?? '',
      htmlUrl: json['html_url'] as String? ?? '',
    );
  }
}

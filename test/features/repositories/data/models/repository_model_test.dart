import 'package:flutter_test/flutter_test.dart';
import 'package:app_github/src/features/repositories/data/models/models.dart';

import '../../repositories_fixtures.dart';

void main() {
  setUpAll(registerDummies);

  group('RepositoryModel.fromJson', () {
    test('parses all fields', () {
      final model = RepositoryModel.fromJson(repositoryJson());

      expect(model.id, 1);
      expect(model.fullName, 'flutter/flutter');
      expect(model.language, 'Dart');
      expect(model.stars, 170000);
      expect(model.forks, 28000);
      expect(model.watchers, 3500);
      expect(model.openIssues, 12000);
      expect(model.license, 'BSD-3-Clause');
      expect(model.topics, ['dart', 'mobile']);
      expect(model.updatedAt, DateTime.utc(2026, 10, 1, 10));
      expect(model.owner.login, 'flutter');
    });

    test('uses defaults for missing fields', () {
      final model = RepositoryModel.fromJson(const {});

      expect(model.id, 0);
      expect(model.name, '');
      expect(model.description, isNull);
      expect(model.license, isNull);
      expect(model.topics, isEmpty);
      expect(model.updatedAt, isNull);
      expect(model.owner.login, '');
    });

    test('falls back to license name when spdx is NOASSERTION', () {
      final json = repositoryJson()
        ..['license'] = {'spdx_id': 'NOASSERTION', 'name': 'Other'};

      expect(RepositoryModel.fromJson(json).license, 'Other');
    });
  });

  test('SearchResultModel.fromJson parses items', () {
    final model = SearchResultModel.fromJson(searchJson(total: 50, count: 3));

    expect(model.totalCount, 50);
    expect(model.incompleteResults, isFalse);
    expect(model.items, hasLength(3));
  });
}

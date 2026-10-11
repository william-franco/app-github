import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:app_github/src/common/patterns/result_pattern.dart';
import 'package:app_github/src/common/patterns/state_pattern.dart';
import 'package:app_github/src/features/repositories/domain/domain.dart';
import 'package:app_github/src/features/repositories/presentation/view_models/view_models.dart';

import '../../repositories_fixtures.dart';
import '../../repositories_mocks.mocks.dart';

void main() {
  setUpAll(registerDummies);

  late RepositoryDetailViewModelImpl viewModel;
  late MockGetRepositoryDetailUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetRepositoryDetailUseCase();
    viewModel = RepositoryDetailViewModelImpl(
      getRepositoryDetailUseCase: mockUseCase,
    );
  });

  test('initial state', () {
    expect(viewModel.state, isA<InitialState>());
  });

  test('emits loading then success', () async {
    final states = <RepositoryDetailState>[];
    viewModel.addListener(() => states.add(viewModel.state));
    when(mockUseCase('a/b'))
        .thenAnswer((_) async => SuccessResult(value: repositoryEntity()));

    await viewModel.fetchDetail('a/b');

    expect(states.first, isA<LoadingState>());
    expect(states.last, isA<SuccessState>());
  });

  test('emits error', () async {
    when(mockUseCase('a/b')).thenAnswer(
      (_) async => const ErrorResult(error: RepositoryException('fail')),
    );

    await viewModel.fetchDetail('a/b');

    expect(viewModel.state, isA<ErrorState>());
  });
}

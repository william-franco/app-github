import 'package:app_github/src/common/patterns/state_pattern.dart';
import 'package:app_github/src/common/state_management/state_management.dart';
import 'package:app_github/src/features/repositories/domain/domain.dart';

typedef RepositoryDetailState =
    StatePattern<RepositoryEntity, RepositoryException>;

abstract class RepositoryDetailViewModel
    extends StateManagement<RepositoryDetailState> {
  Future<void> fetchDetail(String fullName);
}

class RepositoryDetailViewModelImpl extends RepositoryDetailViewModel {
  final GetRepositoryDetailUseCase getRepositoryDetailUseCase;

  RepositoryDetailViewModelImpl({required this.getRepositoryDetailUseCase});

  @override
  RepositoryDetailState build() => const InitialState();

  @override
  Future<void> fetchDetail(String fullName) async {
    emitState(const LoadingState());
    final result = await getRepositoryDetailUseCase(fullName);
    result.fold(
      onSuccess: (repository) => emitState(SuccessState(data: repository)),
      onError: (error) => emitState(ErrorState(error: error)),
    );
  }
}

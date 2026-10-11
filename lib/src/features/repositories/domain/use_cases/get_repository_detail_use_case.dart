import 'package:app_github/src/common/patterns/result_pattern.dart';
import 'package:app_github/src/features/repositories/domain/domain.dart';

abstract interface class GetRepositoryDetailUseCase {
  Future<RepositoryResult> call(String fullName);
}

class GetRepositoryDetailUseCaseImpl implements GetRepositoryDetailUseCase {
  final RepositoriesRepository repositoriesRepository;

  GetRepositoryDetailUseCaseImpl({required this.repositoriesRepository});

  @override
  Future<RepositoryResult> call(String fullName) async {
    final parts = fullName.trim().split('/');
    if (parts.length != 2 || parts.any((part) => part.isEmpty)) {
      return const ErrorResult(
        error: RepositoryException('Invalid repository name.'),
      );
    }
    return repositoriesRepository.getRepository(fullName: fullName.trim());
  }
}

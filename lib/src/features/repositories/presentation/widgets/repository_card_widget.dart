import 'package:flutter/material.dart';
import 'package:app_github/src/common/design/theme_design.dart';
import 'package:app_github/src/common/utils/formatters.dart';
import 'package:app_github/src/features/repositories/domain/domain.dart';
import 'package:app_github/src/features/repositories/presentation/widgets/repo_stat_widget.dart';
import 'package:app_github/src/features/repositories/presentation/widgets/topic_chip_widget.dart';

class RepositoryCardWidget extends StatelessWidget {
  final RepositoryEntity repository;
  final VoidCallback onTap;

  const RepositoryCardWidget({
    super.key,
    required this.repository,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundColor: theme.colorScheme.outline,
                  backgroundImage: repository.owner.avatarUrl.isEmpty
                      ? null
                      : NetworkImage(repository.owner.avatarUrl),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${repository.owner.login} / ',
                          style: TextStyle(color: theme.colorScheme.primary),
                        ),
                        TextSpan(
                          text: repository.name,
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    style: const TextStyle(fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (repository.description?.isNotEmpty ?? false) ...[
              const SizedBox(height: 6),
              Text(
                repository.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: muted, fontSize: 13),
              ),
            ],
            if (repository.topics.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: repository.topics
                    .take(4)
                    .map((topic) => TopicChipWidget(topic: topic))
                    .toList(),
              ),
            ],
            const SizedBox(height: 10),
            Wrap(
              spacing: 16,
              runSpacing: 4,
              children: [
                RepoStatWidget(
                  icon: Icons.star_border,
                  label: Formatters.compactNumber(repository.stars),
                ),
                if (repository.language != null)
                  RepoStatWidget(
                    leading: LanguageDotWidget(
                      color: ThemeDesign.languageColor(repository.language),
                    ),
                    label: repository.language!,
                  ),
                RepoStatWidget(
                  icon: Icons.call_split,
                  label: Formatters.compactNumber(repository.forks),
                ),
                if (repository.updatedAt != null)
                  RepoStatWidget(
                    icon: Icons.history,
                    label: Formatters.relativeDate(repository.updatedAt),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

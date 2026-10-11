import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_github/src/common/design/theme_design.dart';
import 'package:app_github/src/common/patterns/state_pattern.dart';
import 'package:app_github/src/common/state_management/state_management.dart';
import 'package:app_github/src/common/utils/formatters.dart';
import 'package:app_github/src/features/repositories/domain/domain.dart';
import 'package:app_github/src/features/repositories/presentation/view_models/view_models.dart';
import 'package:app_github/src/features/repositories/presentation/widgets/widgets.dart';

class RepositoryDetailView extends StatefulWidget {
  final RepositoryEntity repository;
  final RepositoryDetailViewModel viewModel;

  const RepositoryDetailView({
    super.key,
    required this.repository,
    required this.viewModel,
  });

  @override
  State<RepositoryDetailView> createState() => _RepositoryDetailViewState();
}

class _RepositoryDetailViewState extends State<RepositoryDetailView> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.fetchDetail(widget.repository.fullName);
  }

  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  Future<void> _copyUrl(String url) async {
    await Clipboard.setData(ClipboardData(text: url));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Repository URL copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.repository.fullName)),
      body:
          StateBuilderWidget<RepositoryDetailViewModel, RepositoryDetailState>(
            viewModel: widget.viewModel,
            builder: (context, state) {
              final repository =
                  state is SuccessState<RepositoryEntity, RepositoryException>
                  ? state.data
                  : widget.repository;
              return Column(
                children: [
                  if (state is LoadingState)
                    const LinearProgressIndicator(minHeight: 2),
                  Expanded(child: _body(context, repository)),
                ],
              );
            },
          ),
    );
  }

  Widget _body(BuildContext context, RepositoryEntity repository) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: theme.colorScheme.outline,
              backgroundImage: repository.owner.avatarUrl.isEmpty
                  ? null
                  : NetworkImage(repository.owner.avatarUrl),
            ),
            const SizedBox(width: 8),
            Text(repository.owner.login, style: TextStyle(color: muted)),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          repository.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        if (repository.description?.isNotEmpty ?? false) ...[
          const SizedBox(height: 8),
          Text(repository.description!, style: const TextStyle(fontSize: 15)),
        ],
        if (repository.topics.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: repository.topics
                .map((topic) => TopicChipWidget(topic: topic))
                .toList(),
          ),
        ],
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            RepoStatWidget(
              icon: Icons.star_border,
              label: '${Formatters.compactNumber(repository.stars)} stars',
            ),
            RepoStatWidget(
              icon: Icons.call_split,
              label: '${Formatters.compactNumber(repository.forks)} forks',
            ),
            RepoStatWidget(
              icon: Icons.visibility_outlined,
              label:
                  '${Formatters.compactNumber(repository.watchers)} watching',
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              if (repository.language != null)
                _infoTile(
                  leading: LanguageDotWidget(
                    color: ThemeDesign.languageColor(repository.language),
                  ),
                  title: 'Language',
                  value: repository.language!,
                ),
              _infoTile(
                leading: Icon(Icons.adjust, size: 18, color: muted),
                title: 'Open issues',
                value: '${repository.openIssues}',
              ),
              if (repository.license != null)
                _infoTile(
                  leading: Icon(Icons.balance, size: 18, color: muted),
                  title: 'License',
                  value: repository.license!,
                ),
              if (repository.updatedAt != null)
                _infoTile(
                  leading: Icon(Icons.history, size: 18, color: muted),
                  title: 'Last update',
                  value: Formatters.relativeDate(repository.updatedAt),
                  isLast: true,
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: ThemeDesign.success,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          onPressed: () => _copyUrl(repository.htmlUrl),
          icon: const Icon(Icons.copy, size: 18),
          label: const Text('Copy GitHub URL'),
        ),
      ],
    );
  }

  Widget _infoTile({
    required Widget leading,
    required String title,
    required String value,
    bool isLast = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: ListTile(
        dense: true,
        leading: SizedBox(width: 20, child: Center(child: leading)),
        title: Text(title),
        trailing: Text(value),
      ),
    );
  }
}

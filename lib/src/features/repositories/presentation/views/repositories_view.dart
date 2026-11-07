import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app_github/src/common/patterns/state_pattern.dart';
import 'package:app_github/src/common/state_management/state_management.dart';
import 'package:app_github/src/common/design/widgets/feedback_view_widget.dart';
import 'package:app_github/src/features/repositories/presentation/routes/repositories_routes.dart';
import 'package:app_github/src/features/repositories/presentation/view_models/view_models.dart';
import 'package:app_github/src/features/repositories/presentation/widgets/widgets.dart';

class RepositoriesView extends StatefulWidget {
  final RepositoriesViewModel repositoriesViewModel;

  const RepositoriesView({super.key, required this.repositoriesViewModel});

  @override
  State<RepositoriesView> createState() => _RepositoriesViewState();
}

class _RepositoriesViewState extends State<RepositoriesView> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  RepositoriesViewModel get _viewModel => widget.repositoriesViewModel;

  @override
  void initState() {
    super.initState();
    _searchController.text = _viewModel.state.params.query;
    _scrollController.addListener(_onScroll);
    if (_viewModel.state.status is InitialState) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _viewModel.fetchRepositories(),
      );
    }
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      _viewModel.loadMore();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _openSort(RepositoriesState state) async {
    final selection = await SortBottomSheetWidget.show(
      context,
      sort: state.params.sort,
      order: state.params.order,
    );
    if (selection != null) {
      await _viewModel.changeSort(selection.sort, selection.order);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.code),
        titleSpacing: 0,
        title: const Text('Repositories'),
      ),
      body: StateBuilderWidget<RepositoriesViewModel, RepositoriesState>(
        viewModel: _viewModel,
        builder: (context, state) {
          return Column(
            children: [
              _searchBar(state),
              LanguageFilterWidget(
                selected: state.params.language,
                onSelected: _viewModel.changeLanguage,
              ),
              _resultsHeader(state),
              const Divider(height: 1),
              Expanded(child: _content(state)),
            ],
          );
        },
      ),
    );
  }

  Widget _searchBar(RepositoriesState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onChanged: _viewModel.onQueryChanged,
              onSubmitted: _viewModel.submitQuery,
              decoration: InputDecoration(
                hintText: 'Search repositories',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: ValueListenableBuilder(
                  valueListenable: _searchController,
                  builder: (context, value, _) => value.text.isEmpty
                      ? const SizedBox.shrink()
                      : IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            _viewModel.submitQuery('');
                          },
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: () => _openSort(state),
            icon: const Icon(Icons.sort, size: 18),
            label: const Text('Sort'),
          ),
        ],
      ),
    );
  }

  Widget _resultsHeader(RepositoriesState state) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final text = state.status is SuccessState
        ? '${state.totalCount} results · ${state.params.sort.label}'
        : state.params.sort.label;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text, style: TextStyle(color: muted, fontSize: 12)),
      ),
    );
  }

  Widget _content(RepositoriesState state) {
    return switch (state.status) {
      InitialState() ||
      LoadingState() => const Center(child: CircularProgressIndicator()),
      ErrorState(error: final error) => FeedbackViewWidget(
        icon: Icons.error_outline,
        title: 'Something went wrong',
        message: error.message,
        onAction: _viewModel.refresh,
      ),
      SuccessState() when state.items.isEmpty => const FeedbackViewWidget(
        icon: Icons.search_off,
        title: 'No repositories found',
        message: 'Try a different search or filter.',
      ),
      SuccessState() => RefreshIndicator(
        onRefresh: _viewModel.refresh,
        child: ListView.separated(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: state.items.length + 1,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            if (index == state.items.length) return _footer(state);
            final repository = state.items[index];
            return RepositoryCardWidget(
              repository: repository,
              onTap: () => context.push(
                RepositoriesRoutes.repositoryDetail,
                extra: repository,
              ),
            );
          },
        ),
      ),
    };
  }

  Widget _footer(RepositoriesState state) {
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state.loadMoreError != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(state.loadMoreError!.message, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _viewModel.loadMore,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (!state.hasMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text('End of results')),
      );
    }
    return const SizedBox(height: 16);
  }
}

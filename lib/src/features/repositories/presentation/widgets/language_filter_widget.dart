import 'package:flutter/material.dart';
import 'package:app_github/src/common/design/theme_design.dart';
import 'package:app_github/src/features/repositories/presentation/widgets/repo_stat_widget.dart';

class LanguageFilterWidget extends StatelessWidget {
  static const List<String> languages = [
    'Dart',
    'Kotlin',
    'Swift',
    'TypeScript',
    'JavaScript',
    'Python',
    'Go',
    'Rust',
    'Java',
    'C++',
  ];

  final String? selected;
  final ValueChanged<String?> onSelected;

  const LanguageFilterWidget({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: languages.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _chip(context, label: 'All', isSelected: selected == null);
          }
          final language = languages[index - 1];
          return _chip(
            context,
            label: language,
            isSelected: selected == language,
            color: ThemeDesign.languageColor(language),
          );
        },
      ),
    );
  }

  Widget _chip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    Color? color,
  }) {
    final colors = Theme.of(context).colorScheme;
    return ChoiceChip(
      showCheckmark: false,
      selected: isSelected,
      avatar: color != null ? LanguageDotWidget(color: color) : null,
      label: Text(label),
      labelStyle: TextStyle(
        fontSize: 12,
        color: isSelected ? colors.onPrimary : colors.onSurface,
      ),
      selectedColor: colors.primary,
      backgroundColor: colors.surfaceContainer,
      side: BorderSide(color: isSelected ? colors.primary : colors.outline),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      visualDensity: VisualDensity.compact,
      onSelected: (_) => onSelected(label == 'All' ? null : label),
    );
  }
}

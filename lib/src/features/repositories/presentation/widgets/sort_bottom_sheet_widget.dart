import 'package:flutter/material.dart';
import 'package:app_github/src/common/enums/repositories_enums.dart';

typedef SortSelection = ({SortType sort, OrderType order});

class SortBottomSheetWidget extends StatelessWidget {
  final SortType sort;
  final OrderType order;

  const SortBottomSheetWidget({
    super.key,
    required this.sort,
    required this.order,
  });

  static Future<SortSelection?> show(
    BuildContext context, {
    required SortType sort,
    required OrderType order,
  }) {
    return showModalBottomSheet<SortSelection>(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      builder: (_) => SortBottomSheetWidget(sort: sort, order: order),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context, 'Sort by'),
          ...SortType.values.map(
            (value) => _option(
              context,
              label: value.label,
              selected: value == sort,
              onTap: () => Navigator.pop(context, (sort: value, order: order)),
            ),
          ),
          const Divider(height: 1),
          _header(context, 'Order'),
          ...OrderType.values.map(
            (value) => _option(
              context,
              label: value.label,
              selected: value == order,
              enabled: sort != SortType.bestMatch,
              onTap: () => Navigator.pop(context, (sort: sort, order: value)),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(
        title,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _option(
    BuildContext context, {
    required String label,
    required bool selected,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return ListTile(
      dense: true,
      enabled: enabled,
      leading: SizedBox(
        width: 20,
        child: selected ? const Icon(Icons.check, size: 18) : null,
      ),
      title: Text(label),
      onTap: onTap,
    );
  }
}

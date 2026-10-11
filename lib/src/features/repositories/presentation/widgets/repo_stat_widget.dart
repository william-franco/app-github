import 'package:flutter/material.dart';

class RepoStatWidget extends StatelessWidget {
  final IconData? icon;
  final Widget? leading;
  final String label;

  const RepoStatWidget({
    super.key,
    this.icon,
    this.leading,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        leading ?? Icon(icon, size: 16, color: muted),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: muted, fontSize: 12)),
      ],
    );
  }
}

class LanguageDotWidget extends StatelessWidget {
  final Color color;

  const LanguageDotWidget({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

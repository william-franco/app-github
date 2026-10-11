class Formatters {
  static String compactNumber(int value) {
    if (value >= 1000000) return '${_trim(value / 1000000)}m';
    if (value >= 1000) return '${_trim(value / 1000)}k';
    return '$value';
  }

  static String _trim(double value) {
    final text = value.toStringAsFixed(1);
    return text.endsWith('.0') ? text.substring(0, text.length - 2) : text;
  }

  static String relativeDate(DateTime? date, {DateTime? now}) {
    if (date == null) return '';
    final diff = (now ?? DateTime.now()).difference(date);
    if (diff.inDays >= 365) return 'Updated ${diff.inDays ~/ 365}y ago';
    if (diff.inDays >= 30) return 'Updated ${diff.inDays ~/ 30}mo ago';
    if (diff.inDays >= 1) return 'Updated ${diff.inDays}d ago';
    if (diff.inHours >= 1) return 'Updated ${diff.inHours}h ago';
    return 'Updated ${diff.inMinutes}m ago';
  }
}

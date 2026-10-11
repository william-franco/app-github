enum SortType {
  bestMatch(null, 'Best match'),
  stars('stars', 'Most stars'),
  forks('forks', 'Most forks'),
  updated('updated', 'Recently updated');

  final String? apiValue;
  final String label;

  const SortType(this.apiValue, this.label);
}

enum OrderType {
  desc('desc', 'Descending'),
  asc('asc', 'Ascending');

  final String apiValue;
  final String label;

  const OrderType(this.apiValue, this.label);
}

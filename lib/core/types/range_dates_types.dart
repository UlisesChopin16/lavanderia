enum RangeDatesTypes {
  week(title: 'Una semana'),
  month(title: 'Un mes'),
  threeMonths(title: 'Tres meses');

  final String title;

  const RangeDatesTypes({required this.title});

  List<DateTime> get range {
    final today = DateTime.now();
    final now = DateTime(today.year, today.month, today.day);

    switch (this) {
      case RangeDatesTypes.week:
        final oneWeekAgo = now.subtract(const Duration(days: 7));
        return [oneWeekAgo, now];
      case RangeDatesTypes.month:
        final oneMonthAgo = DateTime(now.year, now.month - 1, now.day);
        return [oneMonthAgo, now];
      case RangeDatesTypes.threeMonths:
        final threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);
        return [threeMonthsAgo, now];
    }
  }
}

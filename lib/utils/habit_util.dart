import '../model/habit.dart';

bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();
  return completedDays.any(
    (date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.month == date.month,
  );
}

Map<DateTime, int> prepareHeatMapDataset(List<Habit> habits) {
  Map<DateTime, int> datasets = {};

  for (var habit in habits) {
    for (var date in habit.completedDays) {
      final normalizeDate = DateTime(date.year, date.month, date.day);

      if (datasets.containsKey(normalizeDate)) {
        datasets[normalizeDate] = datasets[normalizeDate]! + 1;
      } else {
        datasets[normalizeDate] = 1;
      }
    }
  }
  return datasets;
}

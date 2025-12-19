import 'package:isar/isar.dart';

part 'habit.g.dart';

@Collection()
class Habit {
  //unique id
  Id id = Isar.autoIncrement;

  //name
  late String name;

  //completed days
  List<DateTime> completedDays = [];
}

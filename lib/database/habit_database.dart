import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:minimal_habit_tracker/model/app_settings.dart';
import 'package:minimal_habit_tracker/model/habit.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  //INITIALIZING DB
  Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([
      HabitSchema,
      AppSettingsSchema,
    ], directory: dir.path);
  }

  //SAVING FIRST LAUNCH DATE
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstTimeLaunch = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  //GETTING FIRST LAUNCH DATE
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstTimeLaunch;
  }

  //CRUD OPS
  //List of habits
  final List<Habit> currentHabits = [];

  //create new habits
  Future<void> createHabit(String habitName) async {
    //creating it
    final newHabit = Habit()..name = habitName;
    //saving it to db
    await isar.writeTxn(() => isar.habits.put(newHabit));
    //read it from db
    readHabits();
  }

  //read habits
  Future<void> readHabits() async {
    //fetching habits from db
    final List<Habit> fetchedHabits = await isar.habits.where().findAll();

    //giving the fetched habits to the current habits
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);

    //updating the UI
    notifyListeners();
  }

  //update => toggle check
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    //finding the specific habit
    final habit = await isar.habits.get(id);

    //update completion status
    if (habit != null) {
      await isar.writeTxn(() async {
        //if habit is completed add the current date to completedDays list
        if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
          final today = DateTime.now();

          //add the current date to the completedDays list if its not already there
          habit.completedDays.add(DateTime(today.year, today.month, today.day));

          //if habit is not completed remove the current date from the completedDays list
        } else {
          habit.completedDays.removeWhere(
            (date) =>
                date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day,
          );
        }
        //save habit to db
        await isar.habits.put(habit);
      });
    }
    readHabits();
  }

  //update => change name
  Future<void> updateHabitName(int id, String newHabitName) async {
    final habit = await isar.habits.get(id);

    if (habit != null) {
      await isar.writeTxn(() async {
        habit.name = newHabitName;
        await isar.habits.put(habit);
      });
    }
    readHabits();
  }

  //delete habit
  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(()async{
      await isar.habits.delete(id);
    });
    readHabits();
  }
}

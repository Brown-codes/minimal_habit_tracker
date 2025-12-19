import 'package:flutter/material.dart';
import 'package:minimal_habit_tracker/components/my_drawer.dart';
import 'package:minimal_habit_tracker/components/my_habit_tile.dart';
import 'package:minimal_habit_tracker/components/my_heat_map.dart';
import 'package:minimal_habit_tracker/database/habit_database.dart';
import 'package:minimal_habit_tracker/utils/habit_util.dart';
import 'package:provider/provider.dart';

import '../model/habit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
  }

  final TextEditingController _textEditingController = TextEditingController();

  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: _textEditingController,
          decoration: InputDecoration(hintText: "Create a habit"),
        ),
        actions: [
          //save button
          MaterialButton(
            onPressed: () {
              //get name
              String newHabit = _textEditingController.text;

              if (newHabit.trim().isNotEmpty) {
                //save to db
                context.read<HabitDatabase>().createHabit(newHabit);
              }

              //pop ui
              Navigator.pop(context);

              //clear controller
              _textEditingController.clear();
            },
            child: Text("Save"),
          ),

          //delete button
          MaterialButton(
            onPressed: () {
              //pop ui
              Navigator.pop(context);

              //clear controller
              _textEditingController.clear();
            },
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void checkHabitOnAndOff(bool? value, Habit habit) {
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  void editHabit(Habit habit) {
    _textEditingController.text = habit.name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(controller: _textEditingController),
        actions: [
          //save button
          MaterialButton(
            onPressed: () {
              //get name
              String newHabit = _textEditingController.text;

              //save to db
              context.read<HabitDatabase>().updateHabitName(habit.id, newHabit);

              //pop ui
              Navigator.pop(context);

              //clear controller
              _textEditingController.clear();
            },
            child: Text("Save"),
          ),

          //delete button
          MaterialButton(
            onPressed: () {
              //pop ui
              Navigator.pop(context);

              //clear controller
              _textEditingController.clear();
            },
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void deleteHabit(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Are you sure you want to delete this habit?"),
        actions: [
          //delete button
          MaterialButton(
            onPressed: () {
              //save to db
              context.read<HabitDatabase>().deleteHabit(habit.id);

              //pop ui
              Navigator.pop(context);
            },
            child: Text("Delete"),
          ),

          //delete button
          MaterialButton(
            onPressed: () {
              //pop ui
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          "Jisie Ike",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(children: [_buildHeatMapCalendar(), _buildHabitList()]),
      ),
    );
  }

  //heat map calendar
  Widget _buildHeatMapCalendar() {
    //connect db
    final habitDatabase = context.watch<HabitDatabase>();

    //list of current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;
    return FutureBuilder(
      future: habitDatabase.getFirstLaunchDate(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyHeatMap(
            startDate: snapshot.data!,
            datasets: prepareHeatMapDataset(currentHabits),
          );
        } else {
          return Container();
        }
      },
    );
  }

  //habit list
  Widget _buildHabitList() {
    //db
    final habitDataBase = context.watch<HabitDatabase>();

    List<Habit> currentHabits = habitDataBase.currentHabits;
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: currentHabits.length,
      itemBuilder: (context, index) {
        final habit = currentHabits[index];

        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

        return MyHabitTile(
          text: habit.name,
          isCompleted: isCompletedToday,
          onChanged: (value) => checkHabitOnAndOff(value, habit),
          editHabit: (context) => editHabit(habit),
          deleteHabit: (context) => deleteHabit(habit),
        );
      },
    );
  }
}

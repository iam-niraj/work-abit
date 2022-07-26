import 'package:hive/hive.dart';

import '../../data/models/tasks.dart';

class TaskController {
  final String _boxName = "user_Tasks";

  Future<int> addTask(Task newTask) async {
    final box = await Hive.openBox<Task>(_boxName);
    var result = await box.add(newTask);
    return result;
  }

  Future<List<Task>> getTask() async {
    var box = await Hive.openBox<Task>(_boxName);
    var tasks = box.values.toList();
    return tasks;
  }

  Future deleteTask(index) async {
    var box = await Hive.openBox<Task>(_boxName);
    var result = await box.deleteAt(index);
    return result;
  }

  Future markTaskComplete(index) async {
    var box = await Hive.openBox<Task>(_boxName);
    var i = box.getAt(index);
    i!.isCompleted = 1;
    final result = i.save();
    return result;
  }
}

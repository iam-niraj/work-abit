import 'package:hive/hive.dart';

import '../../data/models/events.dart';

class TaskController {
  final String _boxName = "user_Tasks";

  Future<int> addTask(Events event) async {
    final box = await Hive.openBox<Events>(_boxName);
    var result = await box.add(event);
    return result;
  }

  Future<List<Events>> getTasks() async {
    var box = await Hive.openBox<Events>(_boxName);
    var events = box.values.toList();
    return events;
  }

  Future deleteTask(index) async {
    var box = await Hive.openBox<Events>(_boxName);
    var result = await box.deleteAt(index);
    return result;
  }

  Future markTaskComplete(index) async {
    var box = await Hive.openBox<Events>(_boxName);
    var i = box.getAt(index);
    i!.isCompleted = 1;
    final result = i.save();
    return result;
  }
}

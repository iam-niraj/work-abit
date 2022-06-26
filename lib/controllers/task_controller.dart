import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/tasks.dart';

class TaskController extends GetxController {
  final String _boxName = "user_Tasks";

  var taskList = <Task>[].obs;

  void addTask(Task newTask) async {
    final box = await Hive.openBox<Task>(_boxName);
    await box.add(newTask);
  }

  void getTask() async {
    var box = await Hive.openBox<Task>(_boxName);
    // Update our provider state data with a hive read, and refresh the ui
    var tasks = box.values.toList();
    taskList.assignAll(tasks);
  }

  deleteTask(index) async {
    var box = await Hive.openBox<Task>(_boxName);
    await box.deleteAt(index);

    getTask();
  }

  void markTaskComplete(index) async {
    var box = await Hive.openBox<Task>(_boxName);
    /* await box.putAt(task, Task(isCompleted: 1));
    getTask(); */
    var i = box.getAt(index);
    i!.isCompleted = 1;
    i.save();
    getTask();
  }
}

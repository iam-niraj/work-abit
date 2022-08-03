import '../../domain/controllers/task_controller.dart';
import '../models/events.dart';

class EventsRepository {
  // the code below is used to create an instance of the DatabaseController class
  final TaskController dbController = TaskController();

  Future getAllTodos() => dbController.getTasks();

  Future insertTodo(Events events) => dbController.addTask(events);

  Future updateTodo(int index) => dbController.markTaskComplete(index);

  Future deleteTodo(int index) => dbController.deleteTask(index);
}

import 'package:flutter_calendar/data/data_source/task_controller.dart';
import 'package:flutter_calendar/data/data_source/event_table/event_table.dart';
import 'package:flutter_calendar/data/models/event_model/event_model.dart';
import 'package:flutter_calendar/domain/repositories/event_repository.dart';


class EventsRepository extends EventRepository {
  final EventController dbController = EventController();

  /*Future getAllTodos() => dbController.getTasks();

  Future insertTodo(Events events) => dbController.addTask(events);

  Future updateTodo(int index) => dbController.markTaskComplete(index);

  Future deleteTodo(int index) => dbController.deleteTask(index);*/

  @override
  Future create(EventModel event) => dbController.addEvent(event);

  @override
  Future delete(EventModel event, int index) => dbController.deleteEvent(event, index);

  @override
  Stream<List<EventModel>> getAll() => dbController.getAllEvents();

  @override
  Future update(EventModel event, int index) => dbController.markEventComplete(event, index);
}

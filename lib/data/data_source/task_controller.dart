import 'package:flutter_calendar/data/models/event_model/event_model.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/subjects.dart';
import 'event_table/event_table.dart';

class EventController {
  final String _boxName = "user_Tasks";

  final _todoStreamController = BehaviorSubject<List<EventModel>>.seeded(const []);


  EventController(){
    getEvents();
  }

  Future addEvent(EventModel event) async {
    final events = [..._todoStreamController.value];
    final todoIndex = events.indexWhere((t) => t.id == event.id);
    if (todoIndex >= 0) {
      events[todoIndex] = event;
    } else {
      events.add(event);
    }
    _todoStreamController.add(events);
    final box = await Hive.openBox<EventTable>(_boxName);
    final eventTable = EventTable.casteFromModel(event);
    await box.add(eventTable);
  }

  Stream<List<EventModel>> getAllEvents() => _todoStreamController.asBroadcastStream();

  Future getEvents() async {
    var box = await Hive.openBox<EventTable>(_boxName);
    var event = box.values.toList();
    final data = event.map(EventTable.toModel).toList();
    _todoStreamController.add(data);
  }

  Future deleteEvent(event, index) async {
    final todos = [..._todoStreamController.value];
    final todoIndex = todos.indexWhere((t) => t.id == event.id);
    if (todoIndex == -1) {
      throw Exception();
    } else {
      todos.removeAt(todoIndex);
      _todoStreamController.add(todos);

      var box = await Hive.openBox<EventTable>(_boxName);
      await box.deleteAt(index);
    }
  }

  Future markEventComplete(event, index) async {
    final events = [..._todoStreamController.value];
    final todoIndex = events.indexWhere((t) => t.id == event.id);
    if (todoIndex >= 0) {
      events[todoIndex] = event;
    } else {
      events.add(event);
    }
    _todoStreamController.add(events);
    var box = await Hive.openBox<EventTable>(_boxName);
    var i = box.getAt(index);
    i!.isCompleted = 1;
    i.save();
  }
}

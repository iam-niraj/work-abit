import 'package:flutter_calendar/data/data_source/data_source.dart';
import 'package:flutter_calendar/data/models/models.dart';
import 'package:flutter_calendar/domain/repositories/repositories.dart';

class EventsRepositoryImpl extends EventsRepository {
  final EventController dbController = EventController();

  @override
  Future create(EventModel event) => dbController.addEvent(event);

  @override
  Future delete(EventModel event, int index) =>
      dbController.deleteEvent(event, index);

  @override
  Stream<List<EventModel>> getAll() => dbController.getAllEvents();

  @override
  Future update(EventModel event, int index) =>
      dbController.markEventComplete(event, index);
}

import 'package:flutter_calendar/data/models/event_model/event_model.dart';

abstract class EventsRepository {
  Stream<List<EventModel>> getAll();

  Future create(EventModel event);

  Future update(EventModel event, int index);

  Future delete(EventModel event, int index);
}

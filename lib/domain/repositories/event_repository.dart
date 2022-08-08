import 'package:flutter_calendar/data/data_source/event_table/event_table.dart';
import 'package:flutter_calendar/data/models/event_model/event_model.dart';

abstract class EventRepository {
  Stream<List<EventModel>> getAll();

  Future create(EventModel event);

  Future update(EventModel event, int index);

  Future delete(EventModel event, int index);
}
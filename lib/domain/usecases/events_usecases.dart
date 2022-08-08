import 'package:flutter_calendar/data/models/event_model/event_model.dart';
import 'package:flutter_calendar/domain/entities/event_entity.dart';
import 'package:flutter_calendar/domain/repositories/event_repository.dart';

class EventsUseCases {

  EventsUseCases(this.eventRepository);

  final EventRepository eventRepository;

  Stream<List<EventModel>> getAll() => eventRepository.getAll();

  Future create(EventEntity event) {
    final data = EventModel.casteFromEntity(event);
    return eventRepository.create(data);
  }

  Future update(EventEntity event, int index) {
    final data = EventModel.casteFromEntity(event);
    return eventRepository.update(data, index);
  }

  Future delete(EventEntity event, int index) {
    final data = EventModel.casteFromEntity(event);
    return eventRepository.delete(data, index);
  }
}
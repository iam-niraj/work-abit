import 'package:flutter_calendar/data/models/models.dart';
import 'package:flutter_calendar/domain/entities/entities.dart';
import 'package:flutter_calendar/domain/repositories/repositories.dart';

class EventsUseCases {
  EventsUseCases(this.eventRepository);

  final EventsRepository eventRepository;

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

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_calendar/data/models/models.dart';
import 'package:flutter_calendar/domain/entities/entities.dart';
import 'package:flutter_calendar/domain/usecases/usecases.dart';

part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsOverviewState> {
  EventsBloc({
    required EventsUseCases eventsUsecases,
  })  : _eventsUsecases = eventsUsecases,
        super(EventsOverviewState()) {
    on<UpdateEvent>(_updateEvent);
    on<DeleteEvent>(_deleteEvent);
    on<LoadEvents>(loadEvents);
  }

  final EventsUseCases _eventsUsecases;

  Future<void> loadEvents(
      LoadEvents event, Emitter<EventsOverviewState> emit) async {
    emit(state.copyWith(status: () => EventsOverviewStatus.loading));

    await emit.forEach<List<EventModel>>(
      _eventsUsecases.getAll(),
      onData: (events) => state.copyWith(
        status: () => EventsOverviewStatus.success,
        todos: () => events,
      ),
      onError: (_, __) => state.copyWith(
        status: () => EventsOverviewStatus.failure,
      ),
    );
  }

  Future _deleteEvent(
      DeleteEvent event, Emitter<EventsOverviewState> emit) async {
    await _eventsUsecases.delete(event.event, event.index);
  }

  Future _updateEvent(
      UpdateEvent event, Emitter<EventsOverviewState> emit) async {
    final completedEvent = event.event.copyWith(isCompleted: 1);
    await _eventsUsecases.update(completedEvent, event.index);
  }
}

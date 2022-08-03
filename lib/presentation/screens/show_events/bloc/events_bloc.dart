import 'package:bloc/bloc.dart';
import 'package:flutter_calendar/data/repositories/task_repositories.dart';

import '../../../../data/models/events.dart';

part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  EventsBloc({
    required EventsRepository eventsRepository,
  })  : _eventsRepository = eventsRepository,
        super(EventsLoading()) {
    on<AddEvent>(_addEvent);
    on<UpdateEvent>(_updateEvent);
    on<DeleteEvent>(_deleteEvent);
    on<LoadEvents>(loadEvents);
  }

  final EventsRepository _eventsRepository;

  Future<void> loadEvents(LoadEvents event, Emitter<EventsState> emit) async {
    try {
      List<Events> data = await _eventsRepository.getAllTodos();
      emit(EventsLoaded(events: data));
    } on Exception {
      emit(EventsError(
          message: "Could not fetch the list, please try again later!"));
    }
  }

  Future<void> _addEvent(AddEvent event, Emitter<EventsState> emit) async {
    try {
      final state = this.state;
      await _eventsRepository.insertTodo(event.task);
      if (state is EventsLoaded) {
        add(LoadEvents());
      }
    } on Exception {
      emit(EventsError(message: "Could`nt add todo"));
    }
  }

  Future _deleteEvent(DeleteEvent event, Emitter<EventsState> emit) async {
    try {
      final state = this.state;
      await _eventsRepository.deleteTodo(event.id);
      if (state is EventsLoaded) {
        add(LoadEvents());
      }
    } on Exception {
      emit(EventsError(message: "Could'nt add todo"));
    }
  }

  Future _updateEvent(UpdateEvent event, Emitter<EventsState> emit) async {
    try {
      final state = this.state;
      if (state is EventsLoaded) {
        await _eventsRepository.updateTodo(event.id);
        add(LoadEvents());
      }
    } on Exception {
      emit(EventsError(message: "Could'nt add todo"));
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_calendar/data/models/event_model/event_model.dart';
import 'package:flutter_calendar/domain/usecases/usecases.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final EventsUseCases _eventsUsecases;
  StatsBloc({required EventsUseCases eventsUseCases})
      : _eventsUsecases = eventsUseCases,
        super(StatsState()) {
    on<StatsSubscriptionRequested>(_onSubscriptionRequested);
  }
  Future<void> _onSubscriptionRequested(
    StatsSubscriptionRequested event,
    Emitter<StatsState> emit,
  ) async {
    emit(state.copyWith(status: StatsStatus.loading));

    await emit.forEach<List<EventModel>>(
      _eventsUsecases.getAll(),
      onData: (todos) => state.copyWith(
        status: StatsStatus.success,
        totalTodos: todos.length,
        completedTodos: todos.where((todo) => todo.isCompleted == 1).length,
        activeTodos: todos.where((todo) => todo.isCompleted == 0).length,
      ),
      onError: (_, __) => state.copyWith(status: StatsStatus.failure),
    );
  }
}

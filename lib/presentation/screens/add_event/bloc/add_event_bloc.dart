import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_calendar/domain/entities/event_entity.dart';
import 'package:flutter_calendar/domain/usecases/events_usecases.dart';

part 'add_event_event.dart';
part 'add_event_state.dart';

class AddEventBloc extends Bloc<AddEventEvent, AddEventState> {
  final EventsUseCases _eventsUsecases;

  AddEventBloc({required EventsUseCases eventsUsecases}) : _eventsUsecases = eventsUsecases,
        super(AddEventState()) {
    on<AddEventEvent>((event, emit) async {
      emit(state.copyWith(status: AddEventStatus.loading));
      try {
        await _eventsUsecases.create(event.event);
        emit(state.copyWith(status: AddEventStatus.success));
      } catch (e) {
        emit(state.copyWith(status: AddEventStatus.failure));
      }
    });
  }
}

part of 'events_bloc.dart';

abstract class EventsState {}

class EventsLoading extends EventsState {}

class EventsLoaded extends EventsState {
  final List<Events> events;
  EventsLoaded({required this.events});
}

class EventsError extends EventsState {
  final String message;
  EventsError({required this.message});
}

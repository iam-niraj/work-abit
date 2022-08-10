part of 'events_bloc.dart';

abstract class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object> get props => [];
}

class LoadEvents extends EventsEvent {}

class UpdateEvent extends EventsEvent {
  final int index;
  final EventEntity event;
  UpdateEvent(this.event, this.index);

  @override
  List<Object> get props => [index, event];
}

class DeleteEvent extends EventsEvent {
  final int index;
  final EventEntity event;
  DeleteEvent(this.event, this.index);

  @override
  List<Object> get props => [index, event];
}

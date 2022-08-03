part of 'events_bloc.dart';

abstract class EventsEvent {}

class AddEvent extends EventsEvent {
  Events task;

  AddEvent({required this.task});
}

class LoadEvents extends EventsEvent {}

class UpdateEvent extends EventsEvent {
  final int id;

  UpdateEvent(this.id);
}

class DeleteEvent extends EventsEvent {
  final int id;

  DeleteEvent(this.id);
}

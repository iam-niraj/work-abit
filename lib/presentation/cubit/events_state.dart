part of 'events_cubit.dart';

abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoLoaded extends TodoState {
  final List<Task> events;
  TodoLoaded({required this.events});
}

class TodoError extends TodoState {
  final String message;
  TodoError({required this.message});
}

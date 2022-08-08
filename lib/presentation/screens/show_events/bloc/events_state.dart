part of 'events_bloc.dart';

enum EventsOverviewStatus { initial, loading, success, failure }

class EventsOverviewState extends Equatable {
  const EventsOverviewState({
    this.status = EventsOverviewStatus.initial,
    this.events = const [],
  });

  final EventsOverviewStatus status;
  final List<EventModel> events;

  EventsOverviewState copyWith({
    EventsOverviewStatus Function()? status,
    List<EventModel> Function()? todos,
  }) {
    return EventsOverviewState(
      status: status != null ? status() : this.status,
      events: todos != null ? todos() : this.events,
    );
  }

  @override
  List<Object?> get props => [
    status,
    events,
  ];
}

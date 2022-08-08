part of 'add_event_bloc.dart';

class AddEventEvent extends Equatable {
  final EventEntity event;

  AddEventEvent({required this.event});

  @override
  List<Object> get props => [event];
}

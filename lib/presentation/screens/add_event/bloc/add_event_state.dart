part of 'add_event_bloc.dart';

enum AddEventStatus { initial, loading, success, failure }

class AddEventState extends Equatable {

  const AddEventState({
    this.status = AddEventStatus.initial,
  });

  final AddEventStatus status;

  AddEventState copyWith({
    AddEventStatus? status,
  }) {
    return AddEventState(
      status: status ?? this.status,
    );
  }
  @override
  List<Object> get props => [status];
}

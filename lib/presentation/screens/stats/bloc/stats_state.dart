part of 'stats_bloc.dart';

enum StatsStatus { initial, loading, success, failure }

class StatsState extends Equatable {
  const StatsState({
    this.status = StatsStatus.initial,
    this.totalTodos = 0,
    this.completedTodos = 0,
    this.activeTodos = 0,
  });

  final StatsStatus status;
  final int totalTodos;
  final int completedTodos;
  final int activeTodos;

  @override
  List<Object> get props => [status, totalTodos, completedTodos, activeTodos];

  StatsState copyWith({
    StatsStatus? status,
    int? totalTodos,
    int? completedTodos,
    int? activeTodos,
  }) {
    return StatsState(
      status: status ?? this.status,
      totalTodos: totalTodos ?? this.totalTodos,
      completedTodos: completedTodos ?? this.completedTodos,
      activeTodos: activeTodos ?? this.activeTodos,
    );
  }
}

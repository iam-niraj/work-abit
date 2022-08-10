part of 'home_cubit.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  HomeState({this.items = const <Items>[], this.status = HomeStatus.loading});

  final List<Items> items;
  final HomeStatus status;

  HomeState copyWith({
    List<Items>? items,
    HomeStatus? status,
  }) {
    return HomeState(
      items: items ?? this.items,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [items];
}

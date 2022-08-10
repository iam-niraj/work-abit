import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_calendar/data/models/models.dart';
import 'package:flutter_calendar/domain/usecases/usecases.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required IndianHolidaysUseCases indianHolidaysUseCases})
      : _holidaysUseCases = indianHolidaysUseCases,
        super(HomeState());

  IndianHolidaysUseCases _holidaysUseCases;

  setHolidays() async {
    emit(state.copyWith(status: HomeStatus.loading));
    List<Items> items = await _holidaysUseCases.getAll();
    emit(state.copyWith(status: HomeStatus.success, items: items));
  }
}

import 'package:flutter_calendar/data/models/holidays_model/holiday_model.dart';

abstract class IndianHolidaysRepository {
  Future<List<Items>> getAll();
}
import 'package:flutter_calendar/data/data_source/data_source.dart';
import 'package:flutter_calendar/data/models/models.dart';
import 'package:flutter_calendar/domain/repositories/repositories.dart';

class IndianHolidaysRepositoryImpl extends IndianHolidaysRepository {
  @override
  Future<List<Items>> getAll() => getIndianHolidays();
}

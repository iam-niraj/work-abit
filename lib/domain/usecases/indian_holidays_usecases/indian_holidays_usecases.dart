import 'package:flutter_calendar/data/models/models.dart';
import 'package:flutter_calendar/domain/repositories/repositories.dart';

class IndianHolidaysUseCases {
  final IndianHolidaysRepository indianHolidaysRepository;

  IndianHolidaysUseCases(this.indianHolidaysRepository);

  Future<List<Items>> getAll() => indianHolidaysRepository.getAll();
}

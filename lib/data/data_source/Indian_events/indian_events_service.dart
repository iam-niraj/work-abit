import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter_calendar/data/models/models.dart';

Future<List<Items>> getIndianHolidays() async {
  List<Items> items = [];
  try {
    final response =
        await rootBundle.loadString('assets/data_repo/indian_holidays.json');
    final data = json.decode(response);
    final result = HolidayModel.fromJson(data);
    items = result.items;
  } catch (e) {
    log(e.toString());
  }
  return items;
}

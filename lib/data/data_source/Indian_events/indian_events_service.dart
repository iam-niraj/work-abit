import 'dart:convert';
import 'dart:developer';
import 'package:flutter_calendar/data/models/models.dart';
import 'package:http/http.dart' as http;

Future<List<Items>> getIndianHolidays() async {
  List<Items> items = [];
  try {
    final response = await http.get(
      Uri.parse(
          "https://www.googleapis.com/calendar/v3/calendars/en.indian%23holiday%40group.v.calendar.google.com/events?key=AIzaSyD9fvNQ70k784CPN3mQqpmw84Y_fs6KXus"),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // var rest = data["items"] as List;
      // items = rest.map<Items>((json) => Items.fromJson(json)).toList();
      final result = HolidayModel.fromJson(data);
      items = result.items;
    } else {
      print("error");
    }
  } catch (e) {
    log(e.toString());
  }
  return items;
}

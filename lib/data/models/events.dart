import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'events.g.dart';

@HiveType(typeId: 1)
class Events extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? title;

  @HiveField(2)
  String? note;

  @HiveField(3)
  int? isCompleted;

  @HiveField(4)
  DateTime? date;

  @HiveField(5)
  TimeOfDay? startTime;

  @HiveField(6)
  String? endTime;

  @HiveField(7)
  int? color;

  @HiveField(8)
  int? remind;

  @HiveField(9)
  String? repeat;

  Events({
    this.id,
    this.title,
    this.note,
    this.isCompleted,
    this.date,
    this.startTime,
    this.endTime,
    this.color,
    this.remind,
    this.repeat,
  });
}

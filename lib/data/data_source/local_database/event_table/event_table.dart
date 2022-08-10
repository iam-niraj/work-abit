import 'package:flutter/material.dart';
import 'package:flutter_calendar/data/models/models.dart';
import 'package:hive/hive.dart';

part 'event_table.g.dart';

@HiveType(typeId: 1)
class EventTable extends EventModel with HiveObjectMixin {
  @override
  @HiveField(0)
  String? id;

  @override
  @HiveField(1)
  String? title;

  @override
  @HiveField(2)
  String? note;

  @override
  @HiveField(3)
  int? isCompleted;

  @override
  @HiveField(4)
  DateTime? date;

  @override
  @HiveField(5)
  TimeOfDay? startTime;

  @override
  @HiveField(6)
  String? endTime;

  @override
  @HiveField(7)
  int? color;

  @override
  @HiveField(8)
  int? remind;

  @override
  @HiveField(9)
  String? repeat;

  EventTable({
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

  factory EventTable.casteFromModel(EventModel eventEntity) => EventTable(
        id: eventEntity.id,
        title: eventEntity.title,
        note: eventEntity.note,
        isCompleted: eventEntity.isCompleted,
        date: eventEntity.date,
        startTime: eventEntity.startTime,
        endTime: eventEntity.endTime,
        color: eventEntity.color,
        remind: eventEntity.remind,
        repeat: eventEntity.repeat,
      );

  static EventModel toModel(EventTable table) => EventModel(
        id: table.id,
        title: table.title,
        note: table.note,
        isCompleted: table.isCompleted,
        date: table.date,
        startTime: table.startTime,
        endTime: table.endTime,
        color: table.color,
        remind: table.remind,
        repeat: table.repeat,
      );

  EventTable copyWith({
    String? id,
    String? title,
    String? note,
    int? isCompleted,
    DateTime? date,
    TimeOfDay? startTime,
    String? endTime,
    int? color,
    int? remind,
    String? repeat,
  }) {
    return EventTable(
        id: id ?? this.id,
        title: title ?? this.title,
        note: note ?? this.note,
        isCompleted: isCompleted ?? this.isCompleted,
        date: date ?? this.date,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        color: color ?? this.color,
        remind: remind ?? this.remind,
        repeat: repeat ?? this.repeat);
  }

  @override
  List<Object?> get props => [
        id,
        title,
        note,
        isCompleted,
        date,
        startTime,
        endTime,
        color,
        remind,
        repeat
      ];
}

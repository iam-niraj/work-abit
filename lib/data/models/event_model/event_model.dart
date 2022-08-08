import 'package:flutter/material.dart';
import 'package:flutter_calendar/domain/entities/event_entity.dart';

class EventModel extends EventEntity {
  String? id;
  String? title;
  String? note;
  int? isCompleted;
  DateTime? date;
  TimeOfDay? startTime;
  String? endTime;
  int? color;
  int? remind;
  String? repeat;

  EventModel({
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

  factory EventModel.casteFromEntity(EventEntity eventEntity) {
    return EventModel(
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
  }

  @override
  List<Object?> get props => [id, title, note, isCompleted, date, startTime, endTime, color, remind, repeat];
}
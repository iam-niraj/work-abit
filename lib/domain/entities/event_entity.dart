import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class EventEntity extends Equatable {
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

  EventEntity({
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

  EventEntity copyWith({
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
    return EventEntity(
        id: id ?? this.id,
        title: title ?? this.title,
        note: note ?? this.note,
        isCompleted: isCompleted ?? this.isCompleted,
        date: date ?? this.date,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        color: color ?? this.color,
        remind: remind ?? this.remind,
        repeat: repeat ?? this.repeat
    );
  }

  @override
  List<Object?> get props => [id, title, note, isCompleted, date, startTime, endTime, color, remind, repeat];
}
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'tasks.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
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

  Task({
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

/*   Task.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        note = json['note'],
        isCompleted = json['isCompleted'],
        date = json['date'],
        startTime = json['startTime'],
        endTime = json['endTime'],
        color = json['color'],
        remind = json['remind'],
        repeat = json['repeat'];

  toJson() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'isCompleted': isCompleted,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'color': color,
      'remind': remind,
      'repeat': repeat,
    };
  } */
}

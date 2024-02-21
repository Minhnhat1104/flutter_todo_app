import 'package:flutter/material.dart';

class ToDo {
  String? id;
  String? todoText;
  bool isDone;
  DateTime? date;
  TimeOfDay? time;
  ToDo({
    required this.id,
    required this.todoText,
    this.date,
    this.time,
    this.isDone = false,
  });

  static List<ToDo> todoList() {
    return [
      ToDo(id: '02', todoText: 'Làm bài tập về nhà', isDone: true),
      ToDo(
          id: '01',
          todoText: 'Nấu ăn (hiện tại)',
          isDone: false,
          date: DateTime.now(),
          time: TimeOfDay.now()),
    ];
  }
}

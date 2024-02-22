import 'package:flutter/material.dart';

class ToDo {
  String? id;
  String? todoText;
  DateTime? time;
  bool isDone;
  ToDo({
    required this.id,
    required this.todoText,
    required this.time,
    this.isDone = false,
  });

  static List<ToDo> todoList() {
    return [
      ToDo(
          id: '02',
          todoText: 'Làm bài tập về nhà',
          isDone: true,
          time: DateTime.now()),
      ToDo(
          id: '01',
          todoText: 'Nấu ăn (hiện tại)',
          isDone: false,
          time: DateTime.now()),
    ];
  }
}

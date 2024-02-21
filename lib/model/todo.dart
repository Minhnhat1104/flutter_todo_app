class ToDo {
  String? id;
  String? todoText;
  bool isDone;
  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
  });

  static List<ToDo> todoList() {
    return [
      ToDo(id: '01', todoText: 'Nấu ăn', isDone: false),
      ToDo(id: '02', todoText: 'Làm bài tập về nhà', isDone: true),
    ];
  }
}

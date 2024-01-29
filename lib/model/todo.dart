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
      ToDo(id: '01', todoText: 'Morning Excercise 1', isDone: true),
      ToDo(id: '02', todoText: 'Morning Excercise 2', isDone: true),
      ToDo(id: '03', todoText: 'Morning Excercise 3'),
      ToDo(id: '04', todoText: 'Morning Excercise 4'),
      ToDo(id: '05', todoText: 'Morning Excercise 5'),
      ToDo(id: '06', todoText: 'Morning Excercise 6'),
      ToDo(id: '07', todoText: 'Morning Excercise 7'),
    ];
  }
}

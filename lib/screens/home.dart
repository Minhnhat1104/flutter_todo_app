// ignore_for_file: prefer_const_constructors
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/widgets/todo_item.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

enum RadioOption { all, today, upcoming }

class _HomeState extends State<Home> {
  final todosList = ToDo.todoList();
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();
  RadioOption? _radioValue = RadioOption.all;
  TimeOfDay? selectedTime;
  DateTime? selectedDate;

  @override
  void initState() {
    // TODO: implement initState
    _foundToDo = todosList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: tdBGColor,
        appBar: _buildAppBar(),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(children: [
                searchBox(),
                radioFilterBox(),
                Expanded(
                    child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 0, bottom: 20),
                      child: Text(
                        'All ToDos',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w500),
                      ),
                    ),
                    // when add, item is add at bottom, so it need to reversed
                    for (ToDo _todo in _foundToDo.reversed)
                      ToDoItem(
                        todo: _todo,
                        onToDoChanged: _handleTodoChange,
                        onDeleteItem: _handleDeleteItem,
                      )
                  ],
                ))
              ]),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20, right: 20, left: 20),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 0.0),
                              blurRadius: 10.0,
                              spreadRadius: 0.0)
                        ],
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: _todoController,
                      decoration: InputDecoration(
                          hintText: 'Add a new todo item',
                          border: InputBorder.none),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20, right: 20),
                  child: ElevatedButton(
                    child: Text(
                        selectedTime != null && selectedDate != null
                            ? "${_formatDate(selectedDate)} ${selectedTime!.hour}:${selectedTime!.minute}"
                            : 'Select Time',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null) {
                        final TimeOfDay? timeOfDay = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            initialEntryMode: TimePickerEntryMode.dial);

                        if (timeOfDay != null) {
                          setState(() {
                            selectedDate = pickedDate;
                            selectedTime = timeOfDay;
                          });
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tdBlue,
                      minimumSize: Size(60, 60),
                      elevation: 10,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20, right: 20),
                  child: ElevatedButton(
                    child: Text('+',
                        style: TextStyle(fontSize: 40, color: Colors.white)),
                    onPressed: _handleAddItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tdBlue,
                      minimumSize: Size(60, 60),
                      elevation: 10,
                    ),
                  ),
                )
              ]),
            )
          ],
        ));
  }

  void _handleTodoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _handleDeleteItem(ToDo todo) {
    setState(() {
      todosList.removeWhere((element) => element.id == todo.id);
    });
  }

  void _handleAddItem() {
    setState(() {
      todosList.add(ToDo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          todoText: _todoController.text,
          date: selectedDate,
          time: selectedTime));

      selectedDate = null;
      selectedTime = null;
    });

    _todoController.clear();
  }

  void _handleFilter(String keyword) {
    List<ToDo> results = [];
    if (keyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((element) =>
              element.todoText!.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundToDo = results;
    });
  }

  String _formatDate(DateTime? date) {
    return '${date!.day.toString().padLeft(2, '0')}/${date!.month.toString().padLeft(2, '0')}/${date!.year}';
  }

  List<ToDo> _radioFilter(List<ToDo> todoList) {
    return todoList.where((element) {
      if (_radioValue == RadioOption.all) {
        return true;
      } else if (_radioValue == RadioOption.today) {}

      return true;
    }).toList();
  }

  double timeToDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: TextField(
          onChanged: (String keyword) {
            _handleFilter(keyword);
          },
          decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(0),
              prefixIcon: Icon(Icons.search, color: tdBlack, size: 20),
              prefixIconConstraints:
                  BoxConstraints(maxHeight: 20, minWidth: 25),
              border: InputBorder.none,
              hintText: 'Search',
              hintStyle: TextStyle(color: tdGrey))),
    );
  }

  Widget radioFilterBox() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Radio(
                      value: RadioOption.all,
                      groupValue: _radioValue,
                      onChanged: (RadioOption? value) {
                        setState(() {
                          _radioValue = value;
                        });
                      }),
                  Expanded(
                      child: Text(
                    'All',
                    style: TextStyle(fontSize: 16),
                  ))
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Radio(
                      value: RadioOption.today,
                      groupValue: _radioValue,
                      onChanged: (RadioOption? value) {
                        setState(() {
                          _radioValue = value;
                        });
                      }),
                  Expanded(
                      child: Text(
                    'Today',
                    style: TextStyle(fontSize: 16),
                  ))
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Radio(
                      value: RadioOption.upcoming,
                      groupValue: _radioValue,
                      onChanged: (RadioOption? value) {
                        setState(() {
                          _radioValue = value;
                        });
                      }),
                  Expanded(
                    child: Text(
                      'Upcoming',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Icon(
          Icons.menu,
          color: tdBlack,
          size: 30,
        ),
        // Container(
        //   height: 40,
        //   width: 40,
        //   child: ClipRRect(
        //       borderRadius: BorderRadius.circular(20),
        //       child: Image.asset('assets/images/avatar.png')),
        // )
      ]),
    );
  }
}

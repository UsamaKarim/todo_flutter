import 'package:flutter/foundation.dart';

import 'package:dribble_ui/models/todo_item.dart';

@immutable
class Todo {
  const Todo({
    required this.todoItem,
    this.todoItemList = const [],
  });

  final TodoItem todoItem;
  final List<TodoItem> todoItemList;

  @override
  String toString() => 'Todo(todoItem: $todoItem, todoItemList: $todoItemList)';

  Todo copyWith({
    TodoItem? todoItem,
    List<TodoItem>? todoItemList,
  }) {
    return Todo(
      todoItem: todoItem ?? this.todoItem,
      todoItemList: todoItemList ?? this.todoItemList,
    );
  }
}

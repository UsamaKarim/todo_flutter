import 'package:flutter/foundation.dart';
import 'package:dribble_ui/models/todo_item.dart';

@immutable
class Todo {
  const Todo({
    this.todoItem,
    this.todoItemList,
  });

  final TodoItem? todoItem;
  final List<TodoItem>? todoItemList;

  @override
  String toString() => 'Todo(todoItem: $todoItem, todoItemList: $todoItemList)';
}

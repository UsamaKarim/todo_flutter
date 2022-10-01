import 'package:dribble_ui/models/todo.dart';
import 'package:dribble_ui/models/todo_item.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> listOfTodos = [...todoList];

  void addTodo(Todo todo) {
    listOfTodos.add(todo);
    notifyListeners();
  }

  void addNestedTodo(String id, TodoItem nestedTodo) {
    listOfTodos = [
      for (final todo in listOfTodos)
        if (todo.todoItem.id == id)
          todo.copyWith(
            todoItemList: [
              ...todo.todoItemList,
              nestedTodo,
            ],
          )
        // Todo(
        //   todoItem: TodoItem(
        //     id: todo.todoItem.id,
        //     name: todo.todoItem.name,
        //     isDone: todo.todoItem.isDone,
        //     description: todo.todoItem.description,
        //     isFavourite: todo.todoItem.isFavourite,
        //   ),
        //   todoItemList: todo.todoItemList..add(nestedTodo),
        // )
        else
          todo
    ];
    notifyListeners();
  }

  void addNestedTodoStatus(String mainID, String itemID) {
    listOfTodos = [
      for (final todo in listOfTodos)
        if (todo.todoItem.id == mainID)
          // Todo(
          //   todoItem: TodoItem(
          //     id: todo.todoItem.id,
          //     name: todo.todoItem.name,
          //     isDone: todo.todoItem.isDone,
          //     description: todo.todoItem.description,
          //     isFavourite: todo.todoItem.isFavourite,
          //   ),
          todo.copyWith(
            todoItemList: [
              for (final todoItem in todo.todoItemList)
                if (todoItem.id == itemID)
                  // TodoItem(
                  //   id: todoItem.id,
                  //   name: todoItem.name,
                  todoItem.copyWith(
                    isDone: !todoItem.isDone,
                    // description: todoItem.description,
                    // isFavourite: todoItem.isFavourite,
                  )
                else
                  todoItem
            ],
          )
        else
          todo
    ];
    notifyListeners();
  }

  void changeStatus(String id) {
    listOfTodos = [
      for (final todo in listOfTodos)
        if (todo.todoItem.id == id)
          todo.copyWith(
              todoItem: todo.todoItem.copyWith(
            isDone: !todo.todoItem.isDone,
          ))
        // Todo(
        //   todoItem: TodoItem(
        //     id: todo.todoItem.id,
        //     name: todo.todoItem.name,
        //     isDone: todo.todoItem.isDone,
        //     description: todo.todoItem.description,
        //     isFavourite: todo.todoItem.isFavourite,
        //   ),
        //   todoItemList: todo.todoItemList,
        // )
        else
          todo
    ];
    notifyListeners();
  }
}

const _uuid = Uuid();
final todoList = <Todo>[
  Todo(
    todoItem: TodoItem(
      id: _uuid.v4(),
      name: 'Design Review',
      isDone: true,
      description: '08:30 AM • Nikita\'s Office',
      isFavourite: false,
    ),
  ),
  Todo(
    todoItem: TodoItem(
      id: _uuid.v4(),
      name: 'Design Onboarding Pages',
      isDone: false,
      description: '09:00 AM',
      isFavourite: false,
    ),
  ),
  Todo(
    todoItem: TodoItem(
      id: _uuid.v4(),
      name: 'Standups',
      isDone: false,
      description: '10:00 AM • My Home • Daily',
      isFavourite: true,
    ),
  ),
  Todo(
    todoItem: TodoItem(
      id: _uuid.v4(),
      name: 'Design New Screens',
      isDone: true,
      isFavourite: false,
      description: '10:30 AM • Nikita\'s Office',
    ),
    todoItemList: [
      TodoItem(
        id: _uuid.v4(),
        name: 'Onboarding Screen',
        isDone: false,
        isFavourite: false,
        description: '',
      ),
      TodoItem(
        id: _uuid.v4(),
        name: 'Signup Flow',
        isDone: true,
        isFavourite: false,
        description: '',
      ),
      TodoItem(
        id: _uuid.v4(),
        name: 'Checkout Flow',
        isDone: false,
        isFavourite: false,
        description: '',
      ),
    ],
  ),
];

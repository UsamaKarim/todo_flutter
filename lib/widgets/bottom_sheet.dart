import 'package:dribble_ui/models/todo_item.dart';
import 'package:dribble_ui/state/todo_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:dribble_ui/models/todo.dart';
import 'package:dribble_ui/widgets/todo_text_field.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class BottomSheetWidget extends StatefulWidget {
  const BottomSheetWidget({
    Key? key,
    required this.controller,
    required this.todo,
  }) : super(key: key);

  final TextEditingController controller;
  final Todo todo;

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: KeyboardAwareWidget(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TodoTextField(
            addTodo: addNestedTodo,
            controller: controller,
            hintText: 'Write your task',
          ),
          const SizedBox(
            height: 20,
          ),
          CupertinoButton(
            color: Colors.grey,
            onPressed: addNestedTodo,
            child: const Text('ADD TASK'),
          )
        ],
      )),
    );
  }

  void addNestedTodo() {
    if (controller.text.isNotEmpty) {
      final todo = TodoItem(
        id: const Uuid().v4(),
        name: controller.text,
      );
      context.read<TodoProvider>().addNestedTodo(widget.todo.todoItem.id, todo);
    }
    controller.text = '';
    Navigator.of(context).pop();
  }
}

class KeyboardAwareWidget extends StatelessWidget {
  const KeyboardAwareWidget({
    Key? key,
    this.padding = 16,
    required this.child,
  }) : super(key: key);
  final double padding;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final keyboardVisibility = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        top: padding,
        left: padding,
        right: padding,
        bottom: keyboardVisibility > 0 ? keyboardVisibility + padding : padding,
      ),
      child: child,
    );
  }
}

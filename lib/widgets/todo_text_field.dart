import 'package:flutter/material.dart';

class TodoTextField extends StatelessWidget {
  const TodoTextField({
    Key? key,
    required this.addTodo,
    required this.controller,
    required this.hintText,
  }) : super(key: key);

  final VoidCallback addTodo;
  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        suffix: GestureDetector(
          onTap: addTodo,
          child: const Icon(Icons.add),
        ),
      ),
      textInputAction: TextInputAction.done,
      onEditingComplete: addTodo,
      onSubmitted: (value) => addTodo,
    );
  }
}

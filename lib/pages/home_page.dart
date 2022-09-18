import 'package:dribble_ui/models/todo.dart';
import 'package:dribble_ui/models/todo_item.dart';
import 'package:dribble_ui/state/todo_provider.dart';
import 'package:dribble_ui/utils/contants.dart';
import 'package:dribble_ui/widgets/todo_item_widget.dart';
import 'package:dribble_ui/widgets/todo_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'TODAY',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'January 28',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.black45,
              size: 16,
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Consumer<TodoProvider>(
              builder: (context, todo, child) {
                return ListView.builder(
                  itemCount: todoList.length,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemBuilder: ((context, index) {
                    final color = randomColors[index % randomColors.length];
                    return TodoItemWidget(
                      barColor: color,
                      todo: todo.listOfTodos[index],
                    );
                  }),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TodoTextField(
              controller: controller,
              addTodo: addTodo,
              hintText: 'Add a new Todo',
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  void addTodo() {
    if (controller.text.isNotEmpty) {
      final todo = Todo(
        todoItem: TodoItem(
          id: const Uuid().v4(),
          name: controller.text,
        ),
      );
      context.read<TodoProvider>().addTodo(todo);
      controller.text = '';
      FocusScope.of(context).unfocus();
    }
  }
}

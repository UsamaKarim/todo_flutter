import 'package:dribble_ui/pages/home_page.dart';
import 'package:dribble_ui/state/todo_provider.dart';
import 'package:dribble_ui/utils/contants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoProvider(),
      child: MaterialApp(
        title: 'Dribble UI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            iconTheme: iconTheme,
          ),
          iconTheme: iconTheme,
          // primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}
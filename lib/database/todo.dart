import 'package:hive_flutter/hive_flutter.dart';

class TodoDatabase {
  List task = [];
  final tasklist = Hive.box("Todo");
  void createInitialData() {
    task = [
      ["Welcome to todo app", false]
    ];
  }

  void loadData() {
    task = tasklist.get("TodoList");
  }

  void update() {
    tasklist.put("TodoList", task);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/components/todo_tile.dart';

import 'package:todo_app/database/todo.dart';

void main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox("Todo");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final tasklist = Hive.box("Todo");
  TodoDatabase db = TodoDatabase();

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  @override
  void initState() {
    if (tasklist.get("TodoList") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Todo App"),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Add Todo'),
              content: TextField(
                controller: _controller,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => {
                    Navigator.pop(context, 'Cancel'),
                    _controller.clear(),
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    db.task.add([_controller.text, false]);

                    Navigator.pop(context, 'OK');
                    _controller.clear();
                    db.update();
                  }),
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          child: ListView.builder(
            itemCount: db.task.length,
            itemBuilder: (context, index) {
              return Card(
                  margin:
                      const EdgeInsets.only(top: 24.0, left: 12.0, right: 12.0),
                  shadowColor: Colors.black,
                  child: Slidable(
                      startActionPane:
                          ActionPane(motion: const StretchMotion(), children: [
                        SlidableAction(
                          onPressed: (BuildContext context) {
                            (_controller2.text = db.task[index][0])
                                .then(showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Edit Todo'),
                                content: TextField(
                                  controller: _controller2,
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => {
                                      Navigator.pop(context, 'Cancel'),
                                      _controller2.clear()
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => setState(() {
                                      db.task[index] = [
                                        _controller2.text,
                                        false
                                      ];

                                      Navigator.pop(context, 'OK');
                                      _controller2.clear();
                                      db.update();
                                    }),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            ));
                          },
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0)),
                          icon: Icons.edit,
                        )
                      ]),
                      endActionPane:
                          ActionPane(motion: const StretchMotion(), children: [
                        SlidableAction(
                          onPressed: (BuildContext context) {
                            setState(() {
                              db.task.removeAt(index);
                              db.update();
                            });
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0)),
                          icon: Icons.delete,
                        )
                      ]),
                      child: TodoTile(title: db.task[index])));
            },
          ),
        ));
  }
}

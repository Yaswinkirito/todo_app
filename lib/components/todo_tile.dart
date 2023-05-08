import 'package:flutter/material.dart';

class TodoTile extends StatefulWidget {
  const TodoTile({super.key, required this.title});
  final List title;
  @override
  State<TodoTile> createState() => _TodoTileState();
}

class _TodoTileState extends State<TodoTile> {
  bool? _checked = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.title[0],
        style: TextStyle(
            decoration: widget.title[1]
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            fontSize: 20.0),
      ),
      leading: Checkbox(
        value: _checked,
        onChanged: (bool? value) {
          setState(() {
            _checked = value!;
            widget.title[1] = _checked;
          });
        },
      ),
    );
  }
}

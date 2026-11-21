import 'package:flutter/material.dart';
import 'package:todo_app/main.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key, required this.onToggleTheme});

  final VoidCallback onToggleTheme;

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<Todo> _todos = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTodo() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _todos.add(Todo(title: text));
    });
    _controller.clear();
  }

  void _toggleTodo(Todo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteTodo(Todo todo) {
    setState(() {
      _todos.remove(todo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Todos'),
        actions: [
          IconButton(
            onPressed: widget.onToggleTheme,
            icon: const Icon(Icons.brightness_6),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding:  const EdgeInsets.all(6),
            child: Row(
              children: [
                Expanded(child:  TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'what need tobe done?',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_)=> _addTodo(),
                )),
                const SizedBox(width: 8,),
               IconButton.filled(onPressed: _addTodo,
                   icon: const Icon(Icons.add))
              ],
            ),
          ),
          Expanded(
              child: _todos.isEmpty? const Center(child: Text('No Todos yet. add one!'),)
                  :ListView.builder(
                itemCount: _todos.length,
                  itemBuilder: (context, index){
                    final todo = _todos[index];
                    return Dismissible(
                        key: ObjectKey(todo),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(Icons.delete, color: Colors.white ,),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_)=>_deleteTodo(todo),
                        child: CheckboxListTile(value: todo.isDone, onChanged: (_) => _toggleTodo(todo),
                        title: Text(todo.title,style: TextStyle(decoration: todo.isDone ? TextDecoration.lineThrough:null),)
                        ),
                    );
              }
              )
          )
        ]
      ),

    );
  }
}

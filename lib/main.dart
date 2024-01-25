import 'dart:math';

import 'package:flutter/material.dart';
// Import the generated Celest client
import 'package:celest_backend/client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // Initializes Celest in your Flutter app
  celest.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Todo List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TodoListScreen(),
    );
  }
}

class TodoListScreen extends ConsumerStatefulWidget {
  const TodoListScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends ConsumerState<TodoListScreen> {
  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ref.listen(asyncTodosProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
          ),
        );
      }
     });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Enter todo title',
                border: OutlineInputBorder(),
                focusColor: Colors.deepPurple
              ),
            ),
          ),
          ref.watch(asyncTodosProvider).when(
                data: (todos) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        final todo = todos[index];
                        return Dismissible(
                          background: Container(
                            color: Colors.deepPurple,
                            alignment: Alignment.centerLeft,
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          key: Key(todo.id.toString()),
                          onDismissed: (_) {
                            // Delete the todo from the database
                            ref.read(asyncTodosProvider.notifier).deleteTodo(
                                  todo: todo,
                                );
                          },
                          child: ListTile(
                            title: Text(todo.title),
                            leading: Checkbox(
                              value: todo.completed,
                              onChanged: (_) {
                                // Update the todo in the database
                                ref
                                    .read(asyncTodosProvider.notifier)
                                    .updateTodo(
                                      todo: todo.copyWith(
                                        completed: !todo.completed,
                                      ),
                                    );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (error, stackTrace) => Text(error.toString()),
              ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add the todo to the database
          ref.read(asyncTodosProvider.notifier).addTodo(
                title: _textController.text,
                completed: false,
              );
          _textController.clear();
        },
        child: const Icon(Icons.add),
      )
    );
  }
}

final asyncTodosProvider =
    AsyncNotifierProvider<AsyncTodosNotifier, List<Todo>>(() {
  return AsyncTodosNotifier();
});

class AsyncTodosNotifier extends AsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async {
    // Load initial todo list from the remote repository
    return _fetchTodo();
  }

  Future<List<Todo>> _fetchTodo() async {
    final todoList = celest.functions.todo.getTodos();
    return todoList;
  }

  Future<void> addTodo({
    required String title,
    required bool completed,
  }) async {
    state = const AsyncValue.loading();
    // Add the new todo and reload the todo list from the remote repository
    state = await AsyncValue.guard(() async {
      await celest.functions.todo.createTodo(
        title: title,
        completed: completed,
      );
      return _fetchTodo();
    });
  }

  Future<void> updateTodo({
    required Todo todo,
  }) async {
    state = const AsyncValue.loading();
    // Update the todo and reload the todo list from the remote repository
    state = await AsyncValue.guard(() async {
      await celest.functions.todo.updateTodo(
        id: todo.id,
        title: todo.title,
        completed: todo.completed,
      );
      return _fetchTodo();
    });
  }

  Future<void> deleteTodo({
    required Todo todo,
  }) async {
    state = const AsyncValue.loading();
    // Delete the todo and reload the todo list from the remote repository
    state = await AsyncValue.guard(() async {
      await celest.functions.todo.deleteTodo(
        id: todo.id,
      );
      return _fetchTodo();
    });
  }
}

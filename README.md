# 🌟 Celest Todo App

A simple yet elegant Todo application built with Flutter for the frontend and Dart using Celest for the backend. Dive into the world of seamless full-stack development in Dart.

## 🚀 Getting Started

### 1. Create the Flutter App

```bash
flutter create todo-app
```

### 2. Download Celest

Download Celest from the official website:

🔗 [Celest Download](https://celest.dev/download)

### 3. Initialize and Run Celest

```bash
start celest
```

### 4. Run the Flutter App

```bash
flutter run
```

## 📚 Working with Celest

### Define Models

Create your models in:
```bash
celest/lib/models
```

### Define Functions

Create functions to interact with your database in:
```bash
celest/functions/<filename>
```

For example, in `celest/functions/todo`:

```dart
Future<List<Todo>> getTodos() async {
  final response = await dio.get("http://localhost:8000/todos");
  final todos = (response.data as List).map((e) => Todo.fromMap(e)).toList();
  return todos;
}
```

### Initialize Celest Client in Flutter

```dart
// Import the generated Celest client
import 'package:celest_backend/client.dart';

void main() {
  // Initializes Celest in your Flutter app
  celest.init();
  runApp(const ProviderScope(child: MyApp()));
}
```

### Call Celest Function in Client Side

```dart
Future<List<Todo>> _fetchTodo() async {
  final todoList = celest.functions.todo.getTodos();
  return todoList;
}
```

---

### Conclusion

This README provides a basic guide to setting up a Todo application with Flutter and Celest, leveraging Dart for a full-stack experience. Happy coding! 🎉



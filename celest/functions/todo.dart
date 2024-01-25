import 'package:celest_backend/models.dart';
import 'package:dio/dio.dart';

final dio = Dio();

Future<List<Todo>> getTodos() async {
  final response = await dio.get("http://localhost:8000/todos");
  final todos = (response.data as List).map((e) => Todo.fromMap(e)).toList();
  return todos;
}

Future<Todo> createTodo({
  required String title,
  required bool completed,
}) async {
  final response = await dio.post(
    "http://localhost:8000/todos",
    data: {
      "title": title,
      "completed": completed,
    },
  );
  final todo = Todo.fromMap(response.data);
  return todo;
}

Future<Todo> updateTodo({
  required int id,
  required String title,
  required bool completed,
}) async {
  final response = await dio.put(
    "http://localhost:8000/todos/$id",
    data: {
      "title": title,
      "completed": completed,
    },
  );
  final todo = Todo.fromMap(response.data);
  return todo;
}

Future<void> deleteTodo({
  required int id,
}) async {
  await dio.delete(
    "http://localhost:8000/todos/$id",
  );
}



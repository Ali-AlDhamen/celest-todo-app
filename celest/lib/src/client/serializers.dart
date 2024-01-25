// ignore_for_file: type=lint, unused_local_variable, unnecessary_cast, unnecessary_import

import 'package:celest/celest.dart';
import 'package:celest_backend/models.dart';

final class TodoSerializer extends Serializer<Todo> {
  const TodoSerializer();

  @override
  Todo deserialize(Object? value) {
    final serialized = assertWireType<String>(value);
    return Todo.fromJson(serialized);
  }

  @override
  String serialize(Todo value) => value.toJson();
}

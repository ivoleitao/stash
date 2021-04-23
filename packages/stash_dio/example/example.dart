import 'package:dio/dio.dart';
import 'package:stash_dio/stash_dio.dart';

class Task {
  final int? id;
  final String? title;
  final bool? completed;

  Task({this.id, this.title, this.completed = false});

  /// Creates a [Task] from json map
  factory Task.fromJson(Map<String, dynamic> json) => Task(
      id: json['id'] as int?,
      title: json['title'] as String?,
      completed: json['completed'] as bool?);

  /// Creates a json map from a [Task]
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'id': id, 'title': title, 'completed': completed};

  @override
  String toString() {
    return 'Task $id: "$title" is ${completed! ? "completed" : "not completed"}';
  }
}

void main() async {
  // Configures a a dio client
  final dio = Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'))
    ..interceptors.addAll([
      newMemoryCacheInterceptor('/todos/1', 'task'),
      LogInterceptor(
          requestHeader: false,
          requestBody: false,
          responseHeader: false,
          responseBody: false)
    ]);

  // First call, executes the request and response is received
  final task1 = await dio
      .get('/todos/1')
      .then((Response<dynamic> response) => Task.fromJson(response.data));
  print(task1);

  // Second call, executes the request and the response is received from the
  // cache
  final task2 = await dio
      .get('/todos/1')
      .then((Response<dynamic> response) => Task.fromJson(response.data));
  print(task2);
}

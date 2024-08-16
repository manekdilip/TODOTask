import 'dart:convert';
import 'package:hive/hive.dart';

part 'todo.g.dart';

List<Todo> todosFromJson(String str) =>
    List<Todo>.from(json.decode(str).map((x) => Todo.fromJson(x)));

String todosToJson(List<Todo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@HiveType(typeId: 0)
class Todo extends HiveObject {
  Todo(
      {required this.id,
      required this.title,
      required this.description,
      required this.createdDT,
      required this.updatedDT,
      required this.isCompleted,
      required this.isSynced});

  /// ID
  @HiveField(0)
  final String id;

  /// TITLE
  @HiveField(1)
  String title;

  /// SUBTITLE
  @HiveField(2)
  String description;

  /// CREATED AT DATETIME
  @HiveField(3)
  DateTime createdDT;

  /// UPDATED AT DATETIME
  @HiveField(4)
  DateTime updatedDT;

  /// IS COMPLETED
  @HiveField(5)
  bool isCompleted;

  /// IS SYNCED
  @HiveField(6)
  bool isSynced;

  /// create new Task

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        createdDT: DateTime.parse(json["createdDT"]),
        updatedDT: DateTime.parse(json["updatedDT"]),
        isCompleted: json["isCompleted"],
        isSynced: json["isSynced"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "id": id,
        "description": description,
        "createdDT": createdDT.toIso8601String(),
        "updatedDT": updatedDT.toIso8601String(),
        "isCompleted": isCompleted,
        "isSynced": isSynced,
      };
}

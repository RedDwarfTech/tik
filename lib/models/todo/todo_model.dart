import 'package:json_annotation/json_annotation.dart';

part 'todo_model.g.dart';

@JsonSerializable()
class Todo {
  final int id;
  final int parent;
  String name;
  @JsonKey(name: 'completed')
  int isCompleted;

  Todo(this.name, {required this.parent, this.isCompleted = 0, int? id})
      : this.id = id ?? 0;

  Todo copy(Map map,
      {String? name, int? isCompleted, required int id, int? parent}) {
    return Todo(
      name ?? this.name,
      isCompleted: isCompleted ?? this.isCompleted,
      id: id,
      parent: parent ?? this.parent,
    );
  }

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$TodoFromJson()` constructor.
  /// The constructor is named after the source class, in this case User.
  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$TodoFromJson`.
  Map<String, dynamic> toJson() => _$TodoToJson(this);
}

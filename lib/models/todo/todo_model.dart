import 'package:json_annotation/json_annotation.dart';

part 'todo_model.g.dart';

@JsonSerializable()
class TodoTask {
  final int id;
  final int parent;
  String name;
  @JsonKey(name: 'completed')
  int isCompleted;

  TodoTask(this.name, {required this.parent, this.isCompleted = 0, int? id})
      : this.id = id ?? 0;

  TodoTask copy(Map map,
      {String? name, int? isCompleted, required int id, int? parent}) {
    return TodoTask(
      name ?? this.name,
      isCompleted: isCompleted ?? this.isCompleted,
      id: id,
      parent: parent ?? this.parent,
    );
  }

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$TodoFromJson()` constructor.
  /// The constructor is named after the source class, in this case User.
  factory TodoTask.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$TodoFromJson`.
  Map<String, dynamic> toJson() => _$TodoToJson(this);
}

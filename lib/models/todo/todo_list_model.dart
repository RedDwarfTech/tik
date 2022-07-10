import 'package:json_annotation/json_annotation.dart';

part 'todo_list_model.g.dart';

@JsonSerializable()
class TodoList {
  int id;
  int parent_id;
  int node_type;
  String name;
  int color;
  int is_default;

  TodoList(
    this.name, {
    required this.color,
    required int id,
    required int parent_id,
    required int node_type,
    required int is_default,
  })  : this.id = id,
        this.parent_id = parent_id,
        this.node_type = node_type,
        this.is_default = is_default;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$TaskFromJson()` constructor.
  /// The constructor is named after the source class, in this case User.
  factory TodoList.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$TaskFromJson`.
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'todo_list_model.g.dart';

@JsonSerializable()
class TodoList {
  int id;
  int parentId;
  int nodeType;
  String name;
  int color;
  @JsonKey(name: 'code_point')
  int codePoint;

  TodoList(
    this.name, {
    required this.color,
    required this.codePoint,
    required int id,
    required int parentId,
    required int nodeType,
  })  : this.id = id,
        this.parentId = parentId,
        this.nodeType = nodeType;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$TaskFromJson()` constructor.
  /// The constructor is named after the source class, in this case User.
  factory TodoList.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$TaskFromJson`.
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}

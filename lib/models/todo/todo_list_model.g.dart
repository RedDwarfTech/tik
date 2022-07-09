// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoList _$TaskFromJson(Map<String, dynamic> json) {
  return TodoList(json['name'] as String,
      color: json['color'] as int,
      id: json['id'],
      parentId: json['parent_id'],
      nodeType: json['node_type']);
}

Map<String, dynamic> _$TaskToJson(TodoList instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'color': instance.color,
      'parent_id': instance.parentId,
      'node_type': instance.nodeType,
    };

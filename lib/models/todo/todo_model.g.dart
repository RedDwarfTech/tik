// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoTask _$TodoFromJson(Map<String, dynamic> json) {
  return TodoTask(json['name'] as String,
      parent: json['parent'],
      isCompleted: json['is_complete'] as int,
      id: json['id'],
      schedule_time: json["schedule_time"],
      priority: json["priority"],
      description: json["description"]);
}

Map<String, dynamic> _$TodoToJson(TodoTask instance) => <String, dynamic>{
      'id': instance.id,
      'parent': instance.parent,
      'name': instance.name,
      'completed': instance.isCompleted,
      'priority': instance.priority,
      'description': instance.description
    };

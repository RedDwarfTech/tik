
class TodoItem {
  int id;
  int priority;
  String itemName;
  int createdTime;
  int scheduleTime;
  int taskStatus;
  String tags;

  TodoItem({
    required this.id,
    required this.priority,
    required this.itemName,
    required this.createdTime,
    required this.scheduleTime,
    required this.taskStatus,
    required this.tags,
  });

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['id'],
      priority: json['priority'],
      itemName: json['itemName'],
      createdTime: json['createdTime'],
      scheduleTime: json['scheduleTime'],
      taskStatus: json['taskStatus'],
      tags: json['tags']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'priority': priority,
      'itemName': itemName,
      'createdTime': createdTime,
      'scheduleTime': scheduleTime,
      'taskStatus': taskStatus,
      'tags': tags
    };
  }
}

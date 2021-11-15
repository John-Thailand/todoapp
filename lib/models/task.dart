class Task {
  Task({
    required this.documentId,
    required this.taskName,
    required this.createdTime,
    required this.updatedTime,
  });

  String documentId;
  String? taskName;
  DateTime? createdTime;
  DateTime? updatedTime;
}

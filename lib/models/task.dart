class Task {
  Task({
    required this.documentId,
    required this.taskName,
    required this.createdTime,
    required this.updatedTime,
    required this.isFavorite,
    required this.favoriteCount,
  });

  String documentId;
  String? taskName;
  DateTime? createdTime;
  DateTime? updatedTime;
  bool isFavorite;
  int favoriteCount;
}

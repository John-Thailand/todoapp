class Task {
  Task({
    required this.documentId,
    required this.taskName,
    required this.taskDetail,
    required this.genre,
    required this.createdTime,
    required this.updatedTime,
    required this.isFavorite,
    required this.favoriteCount,
  });

  String documentId;
  String? taskName;
  String? taskDetail;
  String? genre;
  DateTime? createdTime;
  DateTime? updatedTime;
  bool isFavorite;
  int favoriteCount;
}

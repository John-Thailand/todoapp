import 'package:todo_app/models/user.dart';

class Task {
  Task({
    required this.documentId,
    required this.taskName,
    required this.userId,
    required this.taskDetail,
    required this.genre,
    required this.createdTime,
    required this.updatedTime,
    required this.isFavorite,
    required this.favoriteCount,
    this.user,
  });

  String documentId;
  String? taskName;
  String userId;
  String? taskDetail;
  String? genre;
  DateTime? createdTime;
  DateTime? updatedTime;
  bool isFavorite;
  int favoriteCount;
  User? user;
}

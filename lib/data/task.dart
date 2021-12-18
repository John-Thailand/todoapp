import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/data/account.dart';

class Task {
  String documentId;
  String? taskName;
  String userId;
  String? taskDetail;
  String? genre;
  DateTime? createdTime;
  DateTime? updatedTime;
  bool isFavorite;
  int favoriteCount;
  Account? user;

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

  // factory Task.fromDoc(DocumentSnapshot doc, int favoriteCount, Account? user) {
  //   return Task(
  //     documentId: doc['newsId'],
  //     taskName: doc['newsImageUrl'],
  //     userId: doc['newsCategoryId'],
  //     taskDetail: doc['newsCategoryName'],
  //     genre: doc['newsSubject'],
  //     createdTime: doc['newsContent'],
  //     updatedTime: doc['createDatetime'],
  //     isFavorite: ,
  //     favoriteCount: favoriteCount,
  //     user: user,
  //   );
  // }
}

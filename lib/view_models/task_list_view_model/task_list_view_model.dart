import 'package:flutter/material.dart';
import 'package:todo_app/data/task.dart';

class TaskListViewModel extends ChangeNotifier {
  int _documentLimit = 3;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Task> _newsModels = [];
  List<Task> get newsModels => _newsModels;

  dynamic _lastDocument;
  dynamic get lastDocument => _lastDocument;

  Future<void> queryNewsModels(/*{required dynamic lastDocument}*/) async {
    // _isLoading = true;
    // notifyListeners();

    // final values = await NewsResource.queryNewsModels(
    //     documentLimit: _documentLimit, lastDocument: _lastDocument);

    // _lastDocument = values['lastDocument'];
    // _newsModels = [..._newsModels, ...values['newsModels']];

    // _isLoading = false;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:norsyaza_etiqa_assestment/todoapp.dart';

class ToDoListState extends ChangeNotifier {
  Box<TodoModel> todoBox = Hive.box<TodoModel>(boxName);

  // to determine time left before due date
  String timeLeft(DateTime endDate) {
    var t = endDate.difference(DateTime.now());

    // if more than 24 hours / 1 day
    if (t.inHours > 24) {
      // if difference is 1 day
      if (t.inDays == 1) {
        return "${t.inDays.toInt()} day";
      }

      // if difference more than 1 day
      return "${t.inDays} days";
    }

    // if time left is between 1 hour to 24 hour
    if (t.inHours < 24 && t.inHours > 1) {
      var hr = t.inHours.toInt();
      var min = hr * 60;
      return "${hr} hrs ${t.inMinutes - min} min";
    }

    if (!t.inMinutes.isNegative) {
      return "${t.inMinutes} minutes";
    }
    // if minutes is in negative
    return "-";
  }

  // mark task as complete
  void markAsCompleted(bool value, int index) async {
    TodoModel todo = todoBox.getAt(index);
    todo.isComplete = value;
    await todo.save();
    notifyListeners();
  }

  // Delete task
  Future<void> removeTask(int index) async {
    await todoBox.deleteAt(index);
    notifyListeners();
  }
}

import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  DateTime startDate;
  @HiveField(3)
  DateTime endDate;
  @HiveField(4)
  bool isComplete;

  TodoModel({
    this.id,
    this.title = '',
    this.startDate,
    this.endDate,
    this.isComplete = false,
  });
}

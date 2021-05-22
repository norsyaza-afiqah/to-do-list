import 'package:flutter/cupertino.dart';
import 'package:norsyaza_etiqa_assestment/todoapp.dart';

class AddTaskState extends ChangeNotifier {
  // ---------------------------- CONSTRUCTORS ----------------------------
  AddTaskState({
    @required this.task,
  });

  // ------------------------------- FIELDS -------------------------------
  final TodoModel task;

  // ------------------------------- METHODS ------------------------------

  // start date parameter
  DateTime _startDate;
  DateTime get startDate => _startDate;
  set startDate(DateTime value) {
    _startDate = value;
    validateStartDate();
    notifyListeners();
  }

  // start date error parameter
  String _startDateError;
  String get startDateError => _startDateError;
  bool get startDateHasError => !_startDateError.isNullOrWhiteSpace;

  // end date parameter
  DateTime _endDate;
  DateTime get endDate => _endDate;
  set endDate(DateTime value) {
    _endDate = value;
    validateEndDate();
    notifyListeners();
  }

  // end date error parameter
  String _endDateError;
  String get endDateError => _endDateError;
  bool get endDateHasError => !_endDateError.isNullOrWhiteSpace;

  // task title parameter
  String _taskTitle;
  String get taskTitle => _taskTitle;
  set taskTitle(String value) {
    _taskTitle = value;
    validateTaskTitle();
    notifyListeners();
  }

  // task title error parameter
  String _taskTitleError;
  String get taskTitleError => _taskTitleError;
  bool get taskTitleHasError => !_taskTitleError.isNullOrWhiteSpace;

  // validate if start date is null
  void validateStartDate() {
    try {
      _startDateError = null;
      if (_startDate == null) {
        _startDateError = 'Start Date required';
      }
    } finally {
      notifyListeners();
    }
  }

  // validate if end date is null
  void validateEndDate() {
    try {
      _endDateError = null;
      if (_endDate == null) {
        _endDateError = 'End Date required';
      }
    } finally {
      notifyListeners();
    }
  }

  // validate if task title is null
  void validateTaskTitle() {
    try {
      _taskTitleError = null;
      if (_taskTitle == null) {
        _taskTitleError = 'Task Title required';
      }
    } finally {
      notifyListeners();
    }
  }

  void validateAll() {
    validateTaskTitle();
    validateStartDate();
    validateEndDate();
    notifyListeners();
  }

  Future<void> getTask() {
    _taskTitle = task.title;
    _startDate = task.startDate;
    _endDate = task.endDate;
    notifyListeners();
    return null;
  }

  Future<String> submit() async{
    validateAll();
    if (taskTitleHasError) {
      return _taskTitleError;
    }

    if (startDateHasError) {
      return _startDateError;
    }

    if (endDateHasError) {
      return _endDateError;
    }

    Box<TodoModel> todoBox = Hive.box<TodoModel>(boxName);
    if (task == null){
      return await createTask(todoBox);
    }
    return updateTask(task.key, todoBox);
  }

  // add task
  Future<String> createTask(Box<TodoModel> box) async {
    TodoModel _task = TodoModel(
      title: _taskTitle,
      startDate: _startDate,
      endDate: _endDate,
      isComplete: false,
    );
    await box.add(_task);
    return null;
  }

  Future<String> updateTask(dynamic key, Box<TodoModel> box) async {
    TodoModel _updatedTask = TodoModel(
      title: _taskTitle,
      startDate: _startDate,
      endDate: _endDate,
      isComplete: false,
    );
    await box.put(key, _updatedTask);
    return null;
  }
}

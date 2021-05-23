import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../todoapp.dart';
import 'state.dart';

class AddTaskPage extends StatelessWidget {
  // ---------------------------- CONSTRUCTORS ----------------------------
  const AddTaskPage({
    @required this.task,
  });

  // ------------------------------- FIELDS -------------------------------
  final TodoModel task;

  // ------------------------------- METHODS ------------------------------
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddTaskState>(
      create: (_) => AddTaskState(task: this.task),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow[800],
          brightness: Brightness.dark,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.router.pop(),
          ),
          title: Text(
            'Add new To-Do List',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
        body: _Body(),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> with AfterLayoutMixin {
  @override
  void afterFirstLayout(BuildContext context) async {
    final state = Provider.of<AddTaskState>(context, listen: false);
    if (state.task != null) {
      await state.getTask();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(30.0),
          child: ListView(
            children: [
              _ToDoTitle(),
              SizedBox(height: 25),
              _StartDate(),
              SizedBox(height: 25),
              _EndDate(),
              SizedBox(height: 25),
            ],
          ),
        ),
        _SubmitButton(),
      ],
    );
  }
}

class _ToDoTitle extends StatelessWidget {
  // ------------------------------- FIELDS -------------------------------
  @override
  Widget build(BuildContext context) {
    return Consumer<AddTaskState>(builder: (_, state, __) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'To-Do Title',
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: 22, color: Colors.grey),
          ),
          SizedBox(height: 15),
          Container(
            child: CustomTextField(
              value: state.taskTitle,
              errorText: state.taskTitleError,
              onChanged: (v) => state.taskTitle = v,
            ),
          ),
        ],
      );
    });
  }
}

class _StartDate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddTaskState>(builder: (_, state, __) {
      return _Date(
        title: 'Start Date',
        value: state.startDate,
        onDateSelected: (s) => state.startDate = s,
        errorText: state.startDateError,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
      );
    });
  }
}

class _EndDate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddTaskState>(builder: (_, state, __) {
      return _Date(
        title: 'End Date',
        value: state.endDate,
        onDateSelected: (e) => state.endDate = e,
        errorText: state.endDateError,
        initialDate: state.startDate,
        firstDate: state.startDate,
      );
    });
  }
}

class _Date extends StatelessWidget {
  // ---------------------------- CONSTRUCTORS ----------------------------
  const _Date({
    @required this.title,
    @required this.value,
    @required this.initialDate,
    @required this.firstDate,
    @required this.onDateSelected,
    @required this.errorText,
  });

  // ------------------------------- FIELDS -------------------------------
  final String title;
  final DateTime value;
  final DateTime initialDate;
  final DateTime firstDate;
  final Function(DateTime) onDateSelected;
  final String errorText;

  // ------------------------------- METHODS ------------------------------
  @override
  Widget build(BuildContext context) {
    return Consumer<AddTaskState>(
      builder: (_, state, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                  color: Colors.grey),
            ),
            SizedBox(height: 15),
            Container(
              child: CustomDatePicker(
                value: value,
                initialDate: initialDate,
                firstDate: firstDate,
                lastDate: DateTime(2090),
                onDateSelected: onDateSelected,
              ),
            ),
            if (errorText != null) SizedBox(height: 10),
            if (errorText != null)
              Text(
                errorText,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddTaskState>(builder: (_, state, __) {
      return Positioned(
        bottom: 0.0,
        left: 0.0,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          color: Colors.black,
          child: MaterialButton(
            child: Text(
              'Create Now',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 22,
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              final result = await showBusyDialog(
                context: context,
                action: () async => await state.submit(),
              );
              if (result != null) {
                return showErrorDialog(
                  context: context,
                  errorMessage: result,
                );
              }
              context.router.pop();
            },
          ),
        ),
      );
    });
  }
}

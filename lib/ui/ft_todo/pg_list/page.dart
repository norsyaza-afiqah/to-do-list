import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:norsyaza_etiqa_assestment/todoapp.dart';
import 'state.dart';

class ToDoListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ToDoListState>(
      create: (_) => ToDoListState(),
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.yellow[800],
          brightness: Brightness.dark,
          title: Text(
            'To-Do List',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Colors.redAccent,
          onPressed: () => context.router.push(AddTaskPageRoute()),
        ),
        body: _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ToDoListState>(builder: (_, state, __) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: ValueListenableBuilder(
          valueListenable: Hive.box<TodoModel>(boxName).listenable(),
          builder: (context, Box<TodoModel> items, _) {
            List<int> keys = items.keys.cast<int>().toList();
            int _length = keys.length;
            if (items.values.isEmpty) {
              return Container(); // if tasks is null
            }
            return ListView.builder(
              itemCount: _length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == _length) {
                  return SizedBox(height: 60); // end of list to add space
                }
                final int key = keys[index];
                final TodoModel data = items.get(key);
                return InkWell(
                  child: _TaskCard(
                    index: index,
                    taskTitle: data.title,
                    startDate: data.startDate.dateFormattedString,
                    endDate: data.endDate.dateFormattedString,
                    timeLeft: state.timeLeft(data.endDate),
                    status: data.isComplete,
                    checkBoxOnChanged: (v) => state.markAsCompleted(v, index),
                  ),
                  onTap: () {
                    context.router.push(AddTaskPageRoute(task: data));
                  },
                );
              },
            );
          },
        ),
      );
    });
  }
}

class _TaskCard extends StatelessWidget {
  // ---------------------------- CONSTRUCTORS ----------------------------
  const _TaskCard({
    @required this.index,
    @required this.taskTitle,
    @required this.startDate,
    @required this.endDate,
    @required this.timeLeft,
    @required this.status,
    @required this.checkBoxOnChanged,
  });

  // ------------------------------- FIELDS -------------------------------
  final int index;
  final String taskTitle;
  final String startDate;
  final String endDate;
  final String timeLeft;
  final bool status;
  final void Function(bool) checkBoxOnChanged;

  // ------------------------------- METHODS ------------------------------
  @override
  Widget build(BuildContext context) {
    return Consumer<ToDoListState>(builder: (_, state, __) {
      return Card(
        elevation: 5,
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TaskTitle(taskTitle: taskTitle),
                      SizedBox(height: 15),
                      _TaskDateInfo(
                        startDate: startDate,
                        endDate: endDate,
                        timeLeft: timeLeft,
                      ),
                    ],
                  ),
                ),
                _TaskStatusAndActionBox(
                  status: status,
                  onChanged: checkBoxOnChanged,
                ),
              ],
            ),
            Positioned(
                top: 2,
                right: 2,
                child: GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: PopupMenuButton(
                      onSelected: (item) async {
                        await state.removeTask(index);
                        // print(index);
                      },
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ];
                      },
                    ),
                  ),
                ))
          ],
        ),
      );
    });
  }
}

class _TaskTitle extends StatelessWidget {
  // ---------------------------- CONSTRUCTORS ----------------------------
  const _TaskTitle({
    @required this.taskTitle,
  });

  // ------------------------------- FIELDS -------------------------------
  final String taskTitle;

  // ------------------------------- METHODS ------------------------------
  @override
  Widget build(BuildContext context) {
    return Text(
      taskTitle,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _TaskDateInfo extends StatelessWidget {
  // ---------------------------- CONSTRUCTORS ----------------------------
  const _TaskDateInfo({
    @required this.startDate,
    @required this.endDate,
    @required this.timeLeft,
  });

  // ------------------------------- FIELDS -------------------------------
  final String startDate;
  final String endDate;
  final String timeLeft;

  // ------------------------------- METHODS ------------------------------
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _TaskDateInfoText(
          title: 'Start Date',
          info: startDate,
        ),
        _TaskDateInfoText(
          title: 'End Date',
          info: endDate,
        ),
        _TaskDateInfoText(
          title: 'Time Left',
          info: timeLeft,
        ),
      ],
    );
  }
}

class _TaskDateInfoText extends StatelessWidget {
  // ---------------------------- CONSTRUCTORS ----------------------------
  const _TaskDateInfoText({
    @required this.title,
    @required this.info,
  });

  // ------------------------------- FIELDS -------------------------------
  final String title;
  final String info;

  // ------------------------------- METHODS ------------------------------
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey),
        ),
        SizedBox(height: 5),
        Text(
          info,
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
        ),
      ],
    );
  }
}

class _TaskStatusAndActionBox extends StatelessWidget {
  // ---------------------------- CONSTRUCTORS ----------------------------
  const _TaskStatusAndActionBox({
    @required this.status,
    @required this.onChanged,
  });

  // ------------------------------- FIELDS -------------------------------
  final bool status;
  final void Function(bool) onChanged;

  // ------------------------------- METHODS ------------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Color(0xffE2DCC6),
      child: Padding(
        padding: EdgeInsets.only(left: 25.0, top: 10.0, bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _TaskStatus(status: status),
            _TaskAction(
              value: status,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskStatus extends StatelessWidget {
  // ---------------------------- CONSTRUCTORS ----------------------------
  const _TaskStatus({
    @required this.status,
  });

  // ------------------------------- FIELDS -------------------------------
  final bool status;

  // ------------------------------- METHODS ------------------------------
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Status  ',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
        children: <TextSpan>[
          TextSpan(
            text: status ? 'Completed' : 'Incomplete',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}

class _TaskAction extends StatelessWidget {
  // ---------------------------- CONSTRUCTORS ----------------------------
  const _TaskAction({
    @required this.value,
    @required this.onChanged,
  });

  // ------------------------------- FIELDS -------------------------------
  final bool value;
  final void Function(bool) onChanged;

  // ------------------------------- METHODS ------------------------------
  @override
  Widget build(BuildContext context) {
    return Consumer<ToDoListState>(builder: (_, state, __) {
      return Row(
        children: [
          Text(
            'Tick if completed',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 12,
              color: Colors.grey[600],
            ),
            maxLines: 2,
          ),
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.yellow[800],
            checkColor: Colors.black,
          )
        ],
      );
    });
  }
}

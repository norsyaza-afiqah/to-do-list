import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:norsyaza_etiqa_assestment/routes/routes.gr.dart';

import 'package:norsyaza_etiqa_assestment/todoapp.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with AfterLayoutMixin {
  @override
  void afterFirstLayout(BuildContext context) async {
    await showBusyDialog(
        context: context,
        action: () async {
          await Future.delayed(
            Duration(seconds: 2),
          );
          await Hive.openBox<TodoModel>(boxName);
        });
    await context.router.replace(ToDoListPageRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(),
      ),
    );
  }
}

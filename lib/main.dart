import 'dart:io';

import 'package:flutter/material.dart' hide Router;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'todoapp.dart';

const String boxName = 'todoBox';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // Directory directory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoModelAdapter());

  runApp(ToDoApp());
}

class ToDoApp extends StatefulWidget {
  @override
  _ToDoAppState createState() => _ToDoAppState();
}

class _ToDoAppState extends State<ToDoApp> {

  final _router = Router();

  @override
  Widget build(BuildContext context) {
    return BusyOverlay(
      child: MaterialApp.router(
        themeMode: ThemeMode.light,
        theme: ThemeData(
          fontFamily: 'Lato',
          splashColor: Colors.white.withOpacity(0.5),
        ),
        onGenerateTitle: (context) => 'eS NRE',
        routerDelegate: _router.delegate(),
        routeInformationParser: _router.defaultRouteParser(),
        builder: (context, router) {
          final window = WidgetsBinding.instance.window;
          final media = MediaQueryData.fromWindow(window);
          return Stack(
            children: [
              Positioned.fill(child: router),
                Positioned(
                  left: 8.0,
                  bottom: 8.0,
                  child: DefaultTextStyle(
                    child: Text(
                      '${media.size.width}×${media.size.height}',
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Lato',
                      fontSize: 10.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}


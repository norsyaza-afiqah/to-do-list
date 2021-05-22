import 'package:auto_route/auto_route.dart';
import 'package:norsyaza_etiqa_assestment/todoapp.dart';

@CupertinoAutoRouter(
  generateNavigationHelperExtension: true,
  routes: [
    CupertinoRoute(
      page: SplashPage,
      initial: true,
    ),

    CupertinoRoute(
      page: ToDoListPage,
    ),

    CupertinoRoute(
      page: AddTaskPage,
    ),
  ]
)

class $Router {}
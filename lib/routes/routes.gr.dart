// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;

import '../todoapp.dart' as _i2;

class Router extends _i1.RootStackRouter {
  Router();

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    SplashPageRoute.name: (entry) {
      return _i1.CupertinoPageX(entry: entry, child: _i2.SplashPage());
    },
    ToDoListPageRoute.name: (entry) {
      return _i1.CupertinoPageX(entry: entry, child: _i2.ToDoListPage());
    },
    AddTaskPageRoute.name: (entry) {
      var args = entry.routeData
          .argsAs<AddTaskPageRouteArgs>(orElse: () => AddTaskPageRouteArgs());
      return _i1.CupertinoPageX(
          entry: entry, child: _i2.AddTaskPage(task: args.task));
    }
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(SplashPageRoute.name, path: '/'),
        _i1.RouteConfig(ToDoListPageRoute.name, path: '/to-do-list-page'),
        _i1.RouteConfig(AddTaskPageRoute.name, path: '/add-task-page')
      ];
}

class SplashPageRoute extends _i1.PageRouteInfo {
  const SplashPageRoute() : super(name, path: '/');

  static const String name = 'SplashPageRoute';
}

class ToDoListPageRoute extends _i1.PageRouteInfo {
  const ToDoListPageRoute() : super(name, path: '/to-do-list-page');

  static const String name = 'ToDoListPageRoute';
}

class AddTaskPageRoute extends _i1.PageRouteInfo<AddTaskPageRouteArgs> {
  AddTaskPageRoute({_i2.TodoModel task})
      : super(name,
            path: '/add-task-page', args: AddTaskPageRouteArgs(task: task));

  static const String name = 'AddTaskPageRoute';
}

class AddTaskPageRouteArgs {
  const AddTaskPageRouteArgs({this.task});

  final _i2.TodoModel task;
}

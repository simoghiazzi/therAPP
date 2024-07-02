import 'package:flutter/material.dart';
import 'package:ANAMNEASY/views/AllPatients/all_patients_screen.dart';
import 'package:ANAMNEASY/views/Home/home_screen.dart';
import 'package:ANAMNEASY/views/NewPatient/new_patient_screen.dart';

class AppRouterDelegate extends RouterDelegate<List<RouteSettings>>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<List<RouteSettings>> {
  // Stack of pages
  final _pages = <Page>[];

  // Flag that indicates if a dialog is open
  bool hasDialog = false;

  @override
  final navigatorKey = GlobalKey<NavigatorState>();

  late BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    buildContext = context;

    return Navigator(
      key: navigatorKey,
      pages: List.of(_pages),
      onPopPage: _onPopPage,
    );
  }

  /// Checks if the router can handle the pop: if yes, it calls [popRoute]
  bool _onPopPage(Route route, dynamic result) {
    if (!route.didPop(result)) {
      return false;
    }
    popRoute();
    return true;
  }

  @override
  Future<bool> popRoute() {
    if (_pages.length <= 1 || _pages.last.name == HomePageScreen.route) {
      return Future.value(false);
    }

    if (!hasDialog) {
      _pages.removeLast();
      notifyListeners();
    }
    return Future.value(true);
  }

  /// Returns the material page based on the [routeSettings.name].
  ///
  /// If [routeSettings.arguments] are present, it passes them to the material page.
  MaterialPage _createPage(RouteSettings routeSettings) {
    late Widget child;
    switch (routeSettings.name) {
      case NewPatientScreen.route:
        child = const NewPatientScreen();
        break;
      case AllPatientsScreen.route:
        child = const AllPatientsScreen();
        break;
      case HomePageScreen.route:
        child = HomePageScreen(pageIndex: routeSettings.arguments as int?);
        break;
    }
    return MaterialPage(
      child: child,
      key: Key(routeSettings.name! + routeSettings.arguments.toString())
          as LocalKey?,
      name: routeSettings.name,
      arguments: routeSettings.arguments,
    );
  }

  /// Push the page specified by the [name] of the route on top of the navigator stack if
  /// the page or the arguments are not equal to the head of the stack.
  void pushPage({required String name, dynamic arguments}) {
    if (_pages.isEmpty ||
        _pages.last.name != name ||
        _pages.last.arguments.runtimeType != arguments.runtimeType) {
      _pages.add(_createPage(RouteSettings(name: name, arguments: arguments)));
      notifyListeners();
    }
  }

  /// It behaves exactly as [pushPage] but it doesn't call the [notifyListeners] method.
  void _addPage({required String name, dynamic arguments}) {
    if (_pages.isEmpty ||
        _pages.last.name != name ||
        _pages.last.arguments.runtimeType != arguments.runtimeType) {
      _pages.add(_createPage(RouteSettings(name: name, arguments: arguments)));
    }
  }

  /// Pop the top-most page off the navigator stack.
  void pop() {
    popRoute();
  }

  /// Get the top-most route of the navigator stack.
  Page getLastRoute() {
    return _pages.last;
  }

  /// Remove the top-most page of the navigator stack and the push the page specified by the [name] of the route.
  void replace({required String name, dynamic arguments}) {
    if (_pages.isNotEmpty) {
      _pages.removeLast();
    }
    _addPage(name: name, arguments: arguments);
    notifyListeners();
  }

  /// Replace all the navigator stack with the pages specified by the [routeSettingsList].
  void replaceAll(List<RouteSettings> routeSettingsList) {
    if (routeSettingsList.isNotEmpty) {
      _pages.clear();
      for (var item in routeSettingsList) {
        _addPage(name: item.name!, arguments: item.arguments);
      }
      notifyListeners();
    }
  }

  /// Replace the navigator stack pages from [start] to the top with
  /// the pages specified by the [routeSettingsList].
  ///
  /// If the provided [start] is not valid, it only adds the pages of the [routeSettingsList]
  /// without removing any page ([start] is valid if 0 < start ≤ [length]).
  void replaceAllButNumber(int start,
      {List<RouteSettings> routeSettingsList = const []}) {
    if (start > 0 && start <= _pages.length && _pages.isNotEmpty) {
      _pages.removeRange(start, _pages.length);
    }
    for (var item in routeSettingsList) {
      _addPage(name: item.name!, arguments: item.arguments);
    }
    notifyListeners();
  }

  /// Function used only for testing purposes since it clears all the stack.
  ///
  /// **Do not call it outside the testing framework.**
  void clear() {
    _pages.clear();
    notifyListeners();
  }

  /// Return the navigator stack
  List<Page> get stack => _pages;

  @override
  Future<void> setNewRoutePath(configuration) async {/* Do Nothing */}
}

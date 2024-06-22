import 'package:flutter/material.dart';

import 'route_config.dart';

class SimpleRouterDelegate extends RouterDelegate<Uri>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final _key = GlobalKey<NavigatorState>();
  final List<RouteConfig> routes;

  SimpleRouterDelegate({required this.routes});

  @override
  Uri? get currentConfiguration => _currentPath;

  Uri? _currentPath;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        _buildpage(context, _currentPath?.path ?? '/'),
      ],
      onPopPage: (route, result) {
        return true;
      },
    );
  }

  MaterialPage _buildpage(BuildContext context, String path) {
    final matchingRoute = _findMatchingRoutes(routes, path);
    if (matchingRoute == null) {
      return MaterialPage(
        child: Scaffold(
          body: Center(
            child: Text('404 $path not found'),
          ),
        ),
      );
    }
    final params = matchingRoute.extractParams(_currentPath?.path ?? '/');
    final queryParams =
        matchingRoute.extractQueryParams(_currentPath?.path ?? '/');

    return MaterialPage(
      key: ValueKey(path),
      child: matchingRoute.builder(context, params, queryParams),
    );
  }

  RouteConfig? _findMatchingRoutes(List<RouteConfig> routes, String path) {
    for (var route in routes) {
      if (route.hasMatch(path)) {
        return route;
      }
    }
    return null;
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _key;

  @override
  Future<void> setNewRoutePath(Uri configuration) async {
    _currentPath = configuration;
    notifyListeners();
  }

  void navigateTo(String path) {
    _currentPath = Uri.parse(path);
    notifyListeners();
  }
}

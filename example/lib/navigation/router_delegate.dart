import 'package:flutter/material.dart';
import 'nested_navigator.dart';
import 'route_config.dart';

// class WouterRouterDelegate extends RouterDelegate<Uri>
//     with ChangeNotifier, PopNavigatorRouterDelegateMixin<Uri> {
//   final List<RouteConfig> routes;
//   final Listenable? refreshListenable;
//   Uri? _currentUri;
//   final _key = GlobalKey<NavigatorState>();
//   List<Page> _pages = [];

//   @override
//   GlobalKey<NavigatorState> get navigatorKey => _key;

//   WouterRouterDelegate({required this.routes, this.refreshListenable}) {
//     _currentUri = Uri.parse('/');
//     refreshListenable?.addListener(notifyListeners);
//   }

//   @override
//   Uri? get currentConfiguration => _currentUri;

//   @override
//   Widget build(BuildContext context) {
//     if (_pages.isEmpty) {
//       _pages.add(_buildPage('/', context));
//     }
//     return Navigator(
//       key: navigatorKey,
//       pages: List.of(_pages),
//       onPopPage: (route, result) {
//         if (!route.didPop(result)) {
//           return false;
//         }
//         _pages.removeLast();
//         notifyListeners();
//         return true;
//       },
//     );
//   }

//   MaterialPage _buildPage(String path, BuildContext context) {
//     final matchingRoute = _findMatchingRoute(routes, path);

//     if (matchingRoute == null) {
//       return MaterialPage(
//         key: const ValueKey('404'),
//         child: Scaffold(
//           appBar: AppBar(title: const Text('404')),
//           body: Center(child: Text('404 - $path Not Found')),
//         ),
//       );
//     }

//     final pathParams = matchingRoute.extractParams(path);
//     final queryParams = matchingRoute.extractQueryParams(path);

//     if (matchingRoute.redirect != null) {
//       final redirectPath = matchingRoute.redirect!(_currentUri!);
//       if (redirectPath != null && redirectPath != _currentUri.toString()) {
//         _currentUri = Uri.parse(redirectPath);
//         return _buildPage(redirectPath, context);
//       }
//     }

//     if (matchingRoute.guard != null && !matchingRoute.guard!()) {
//       return MaterialPage(
//         key: const ValueKey('not-allowed'),
//         child: Scaffold(
//           appBar: AppBar(title: const Text('Not Allowed')),
//           body: const Center(
//               child: Text('You are not allowed to view this page')),
//         ),
//       );
//     }

//     if (matchingRoute.nestedRoutes != null) {
//       final childPath = path.length > matchingRoute.path.length
//           ? path.substring(matchingRoute.path.length + 1)
//           : '';
//       final nestedRoute =
//           _findMatchingRoute(matchingRoute.nestedRoutes!, childPath);
//       if (nestedRoute != null) {
//         return MaterialPage(
//           key: ValueKey(path),
//           child: NestedNavigator(
//             nestedRoutes: matchingRoute.nestedRoutes!,
//             initialPath: childPath,
//           ),
//         );
//       }
//     }

//     return MaterialPage(
//       key: ValueKey(path),
//       child: matchingRoute.builder(context, pathParams, queryParams),
//     );
//   }

//   RouteConfig? _findMatchingRoute(List<RouteConfig> routes, String path) {
//     for (var route in routes) {
//       if (route.hasMatch(path)) {
//         return route;
//       }
//       if (route.nestedRoutes != null) {
//         final nestedRoute = _findMatchingRoute(route.nestedRoutes!, path);
//         if (nestedRoute != null) {
//           return nestedRoute;
//         }
//       }
//     }
//     return null;
//   }

//   @override
//   Future<void> setNewRoutePath(Uri configuration) async {
//     _currentUri = configuration;
//     _pages.add(_buildPage(configuration.path, navigatorKey.currentContext!));
//     notifyListeners();
//   }

//   void navigateTo(String path) {
//     _currentUri = Uri.parse(path);
//     _pages.add(_buildPage(path, navigatorKey.currentContext!));
//     notifyListeners();
//   }

//   void refresh() {
//     notifyListeners();
//   }

//   @override
//   Future<bool> popRoute() async {
//     final nestedNavigator = NestedNavigator.of(navigatorKey.currentContext!);
//     if (nestedNavigator != null && nestedNavigator.canPop()) {
//       nestedNavigator.pop();
//       return true;
//     }

//     if (navigatorKey.currentState!.canPop()) {
//       navigatorKey.currentState!.pop();
//       return true;
//     }

//     if (_pages.length > 1) {
//       _pages.removeLast();
//       notifyListeners();
//       return true;
//     }
//     return false;
//   }

//   @override
//   void dispose() {
//     refreshListenable?.removeListener(notifyListeners);
//     super.dispose();
//   }
// }

class WouterRouterDelegate extends RouterDelegate<Uri>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Uri> {
  final List<RouteConfig> routes;
  final Listenable? refreshListenable;
  Uri? _currentUri;
  final GlobalKey<NavigatorState> _key = GlobalKey<NavigatorState>();
  List<Page> _pages = [];

  @override
  GlobalKey<NavigatorState> get navigatorKey => _key;

  WouterRouterDelegate({required this.routes, this.refreshListenable}) {
    _currentUri = Uri.parse('/');
    refreshListenable?.addListener(notifyListeners);
  }

  @override
  Uri? get currentConfiguration => _currentUri;

  @override
  Widget build(BuildContext context) {
    if (_pages.isEmpty) {
      _pages.add(_buildPage('/', context));
    }

    return Navigator(
      key: navigatorKey,
      pages: List.of(_pages),
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        _pages.removeLast();
        _updateCurrentUri();
        notifyListeners();
        return true;
      },
    );
  }

  MaterialPage _buildPage(String path, BuildContext context) {
    final matchingRoute = _findMatchingRoute(routes, path);

    if (matchingRoute == null) {
      return MaterialPage(
        key: const ValueKey('404'),
        child: Scaffold(
          appBar: AppBar(title: const Text('404')),
          body: Center(child: Text('404 - $path Not Found')),
        ),
      );
    }

    final pathParams = matchingRoute.extractParams(path);
    final queryParams = matchingRoute.extractQueryParams(path);

    if (matchingRoute.redirect != null) {
      final redirectPath = matchingRoute.redirect!(_currentUri!);
      if (redirectPath != null && redirectPath != _currentUri.toString()) {
        _currentUri = Uri.parse(redirectPath);
        return _buildPage(redirectPath, context);
      }
    }

    if (matchingRoute.guard != null && !matchingRoute.guard!()) {
      return MaterialPage(
        key: const ValueKey('not-allowed'),
        child: Scaffold(
          appBar: AppBar(title: const Text('Not Allowed')),
          body: const Center(
              child: Text('You are not allowed to view this page')),
        ),
      );
    }

    if (matchingRoute.nestedRoutes != null) {
      final childPath = path.length > matchingRoute.path.length
          ? path.substring(matchingRoute.path.length + 1)
          : null;
      if (childPath != null && childPath.isNotEmpty) {
        return MaterialPage(
          key: ValueKey(path),
          child: NestedNavigator(
            nestedRoutes: matchingRoute.nestedRoutes!,
            initialPath: childPath,
          ),
        );
      }
    }

    return MaterialPage(
      key: ValueKey(path),
      child: matchingRoute.builder(context, pathParams, queryParams),
    );
  }

  RouteConfig? _findMatchingRoute(List<RouteConfig> routes, String path) {
    for (var route in routes) {
      if (route.hasMatch(path)) {
        return route;
      }
      if (route.nestedRoutes != null) {
        final nestedRoute = _findMatchingRoute(route.nestedRoutes!, path);
        if (nestedRoute != null) {
          return nestedRoute;
        }
      }
    }
    return null;
  }

  @override
  Future<void> setNewRoutePath(Uri configuration) async {
    _currentUri = configuration;
    _pages.clear();
    _pages.add(_buildPage(configuration.path, navigatorKey.currentContext!));
    notifyListeners();
  }

  void navigateTo(String path) {
    _currentUri = Uri.parse(path);
    _pages.add(_buildPage(path, navigatorKey.currentContext!));
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }

  @override
  Future<bool> popRoute() async {
    final nestedNavigator = NestedNavigator.of(navigatorKey.currentContext!);
    if (nestedNavigator != null && nestedNavigator.canPop()) {
      nestedNavigator.pop();
      return true;
    }

    if (navigatorKey.currentState!.canPop()) {
      navigatorKey.currentState!.pop();
      return true;
    }

    if (_pages.length > 1) {
      _pages.removeLast();
      notifyListeners();
      return true;
    }
    return false;
  }

  void _updateCurrentUri() {
    if (_pages.isNotEmpty) {
      final lastPage = _pages.last;
      if (lastPage is MaterialPage) {
        final path = (lastPage.key as ValueKey<String>?)?.value;
        if (path != null && path.isNotEmpty) {
          _currentUri = Uri.parse(path);
        }
      }
    }
  }

  @override
  void dispose() {
    refreshListenable?.removeListener(notifyListeners);
    super.dispose();
  }
}

import 'package:flutter/material.dart';

import 'route_config.dart';

class NestedNavigator extends StatefulWidget {
  final List<RouteConfig> nestedRoutes;
  final String initialPath;

  const NestedNavigator({
    super.key,
    required this.nestedRoutes,
    required this.initialPath,
  });

  @override
  State<NestedNavigator> createState() => _NestedNavigatorState();

  bool canPop(BuildContext context) {
    final _NestedNavigatorState? state =
        context.findAncestorStateOfType<_NestedNavigatorState>();
    return state?.canPop() ?? false;
  }

  void pop(BuildContext context) {
    final _NestedNavigatorState? state =
        context.findAncestorStateOfType<_NestedNavigatorState>();
    state?.pop();
  }

  // ignore: library_private_types_in_public_api
  static _NestedNavigatorState? of(BuildContext context) {
    return context.findAncestorStateOfType<_NestedNavigatorState>();
  }
}

class _NestedNavigatorState extends State<NestedNavigator> {
  final GlobalKey<NavigatorState> _nestedNavigatorKey =
      GlobalKey<NavigatorState>();
  late List<Page> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [_buildNestedPage(widget.initialPath, context)];
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _nestedNavigatorKey,
      pages: List.of(_pages),
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        setState(() {
          _pages.removeLast();
        });
        return true;
      },
    );
  }

  MaterialPage _buildNestedPage(String path, BuildContext context) {
    final matchingRoute = widget.nestedRoutes.firstWhere(
      (route) => route.hasMatch(path),
      orElse: () => RouteConfig(
        path: '/404',
        builder: (context, params, queryParams) => Scaffold(
          appBar: AppBar(title: const Text('404')),
          body: Center(child: Text('404 - $path Not Found')),
        ),
      ),
    );

    final pathParams = matchingRoute.extractParams(path);
    final queryParams = matchingRoute.extractQueryParams(path);

    return MaterialPage(
      key: ValueKey(path),
      child: matchingRoute.builder(context, pathParams, queryParams),
    );
  }

  bool canPop() {
    return _pages.length > 1;
  }

  void pop() {
    if (canPop()) {
      setState(() {
        _pages.removeLast();
      });
    }
  }

  void push(String path) {
    setState(() {
      _pages.add(_buildNestedPage(path, context));
    });
  }
}

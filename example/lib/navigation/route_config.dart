import 'package:flutter/widgets.dart';

class RouteConfig {
  final String path;
  final Widget Function(BuildContext, Map<String, String>, Map<String, String>)
      builder;
  final bool Function()? guard;
  final List<RouteConfig>? nestedRoutes;
  final String? Function(Uri)? redirect;

  RouteConfig({
    required this.path,
    required this.builder,
    this.guard,
    this.nestedRoutes,
    this.redirect,
  });

  bool hasMatch(String path) {
    final uri = Uri.parse(path);
    final routeUri = Uri.parse(this.path);

    if (routeUri.pathSegments.length != uri.pathSegments.length) {
      return false;
    }

    for (int i = 0; i < routeUri.pathSegments.length; i++) {
      final routeSegment = routeUri.pathSegments[i];
      final pathSegment = uri.pathSegments[i];

      if (routeSegment.startsWith(':')) {
        continue;
      }

      if (routeSegment != pathSegment) {
        return false;
      }
    }

    return true;
  }

  Map<String, String> extractParams(String path) {
    final uri = Uri.parse(path);
    final routeUri = Uri.parse(this.path);
    final params = <String, String>{};

    for (int i = 0; i < routeUri.pathSegments.length; i++) {
      final routeSegment = routeUri.pathSegments[i];
      final pathSegment = uri.pathSegments[i];

      if (routeSegment.startsWith(':')) {
        params[routeSegment.substring(1)] = pathSegment;
      }
    }

    return params;
  }

  Map<String, String> extractQueryParams(String path) {
    final uri = Uri.parse(path);
    return uri.queryParameters;
  }
}

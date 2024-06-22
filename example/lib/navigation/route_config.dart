import 'package:flutter/material.dart';

class RouteConfig {
  final String path;
  final Widget Function(BuildContext, Map<String, String>, Map<String, String>)
      builder;

  RouteConfig({required this.path, required this.builder});

  bool hasMatch(String path) {
    final routeUri = Uri.parse(this.path);
    final uri = Uri.parse(path);

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
    final routeUri = Uri.parse(this.path);
    final uri = Uri.parse(path);
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

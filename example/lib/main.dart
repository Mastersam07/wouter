import 'package:example/navigation/route_config.dart';
import 'package:example/navigation/route_info_parser.dart';
import 'package:flutter/material.dart';

import 'navigation/router_delegate.dart';

final routeDelegate = SimpleRouterDelegate(
  routes: [
    RouteConfig(path: '/', builder: (context, _, __) => const HomeScreen()),
    RouteConfig(
        path: '/about', builder: (context, _, __) => const AboutScreen()),
    RouteConfig(
      path: '/search',
      builder: (context, _, queryParams) => SearchScreen(
        queryParams: queryParams,
      ),
    ),
  ],
);
final routeInfoParser = SimpleRouteInformationParser();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routeInformationParser: routeInfoParser,
      routerDelegate: routeDelegate,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => routeDelegate.navigateTo('/about'),
              child: const Text('Go to about'),
            ),
            ElevatedButton(
              onPressed: () => routeDelegate.navigateTo('/search'),
              child: const Text('Go to search'),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('About'),
      ),
    );
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key, required this.queryParams});

  final Map<String, String> queryParams;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Search'),
            if (queryParams.isNotEmpty)
              Text(
                'Query: ${queryParams.entries.map((e) => '${e.key}=${e.value}').join(", ")}',
              ),
          ],
        ),
      ),
    );
  }
}

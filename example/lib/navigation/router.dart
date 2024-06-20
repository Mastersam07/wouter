import 'package:flutter/material.dart';

import '../auth_provider.dart';
import '../screens.dart';
import 'route_config.dart';
import 'route_info_parser.dart';
import 'router_delegate.dart';

final WouterRouteInformationParser routeInformationParser =
    WouterRouteInformationParser();

final WouterRouterDelegate routerDelegate = WouterRouterDelegate(
  routes: [
    RouteConfig(
      path: '/',
      builder: (context, pathParams, queryParams) => const HomeScreen(),
    ),
    RouteConfig(
      path: '/about',
      builder: (context, pathParams, queryParams) => const AboutScreen(),
    ),
    RouteConfig(
      path: '/products',
      builder: (context, pathParams, queryParams) =>
          const ProductListingScreen(),
      guard: () => authProvider.isLoggedIn,
    ),
    // Sample with path param
    RouteConfig(
      path: '/products/:id',
      builder: (context, pathParams, queryParams) {
        return ProductScreen(
          productId: int.parse(pathParams['id'] ?? ''),
        );
      },
    ),
    // Sample with query param
    RouteConfig(
      path: '/search',
      builder: (context, pathParams, queryParams) =>
          SearchScreen(queryParams: queryParams),
    ),
    // Sample with nested navigation
    RouteConfig(
      path: '/tabs',
      builder: (context, pathParams, queryParams) =>
          TabsScreen(pathParams: pathParams, queryParams: queryParams),
      nestedRoutes: [
        RouteConfig(
          path: 'tabs/tab1',
          builder: (context, pathParams, queryParams) => Scaffold(
            appBar: AppBar(title: const Text('Tab 1')),
            body: const Center(child: Text('Tab 1 Content')),
          ),
        ),
        RouteConfig(
          path: 'tabs/tab2',
          builder: (context, pathParams, queryParams) => Scaffold(
            appBar: AppBar(title: const Text('Tab 2')),
            body: const Center(child: Text('Tab 2 Content')),
          ),
        ),
      ],
    ),
    RouteConfig(
      path: '/nav',
      builder: (context, pathParams, queryParams) => const NavScreen(),
      nestedRoutes: [
        RouteConfig(
          path: 'nav/nav1',
          builder: (context, pathParams, queryParams) => Scaffold(
            appBar: AppBar(title: const Text('Nav 1')),
            body: const Center(child: Text('Nav 1 Content')),
          ),
        ),
        RouteConfig(
          path: 'nav/nav2',
          builder: (context, pathParams, queryParams) => Scaffold(
            appBar: AppBar(title: const Text('Nav 2')),
            body: const Center(child: Text('Nav 2 Content')),
          ),
        ),
      ],
    ),
    RouteConfig(
      path: '/login',
      builder: (context, pathParams, queryParams) => const LoginScreen(),
    ),
    RouteConfig(
      path: '/profile',
      builder: (context, pathParams, queryParams) => const ProfileScreen(),
      redirect: (uri) => authProvider.isLoggedIn ? null : '/login',
    ),
  ],
  refreshListenable: authProvider,
);

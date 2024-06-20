import 'package:example/auth_provider.dart';
import 'package:example/navigation/router.dart';
import 'package:flutter/material.dart';

import 'navigation/router_delegate.dart';

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
              onPressed: () => routerDelegate.navigateTo('/about'),
              child: const Text('Go to About'),
            ),
            ElevatedButton(
                onPressed: () => routerDelegate.navigateTo('/products'),
                child: const Text('Go to Listing')),
            ElevatedButton(
                onPressed: () => routerDelegate.navigateTo('/tabs'),
                child: const Text('Go to Tab')),
            ElevatedButton(
                onPressed: () => routerDelegate.navigateTo('/nav'),
                child: const Text('Go to Nav')),
            ElevatedButton(
                onPressed: () => routerDelegate.navigateTo('/search'),
                child: const Text('Go to Search')),
            ElevatedButton(
                onPressed: () => routerDelegate.navigateTo('/login'),
                child: const Text('Go to Login')),
            ElevatedButton(
                onPressed: () => routerDelegate.navigateTo('/profile'),
                child: const Text('Go to Profile')),
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
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('About'),
      ),
    );
  }
}

class ProductListingScreen extends StatelessWidget {
  const ProductListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text('Products'),
      ),
      body: ListView.builder(
        itemCount: 30,
        itemBuilder: (_, int index) => ListTile(
          onTap: () => routerDelegate.navigateTo('/products/$index'),
          title: Text('Product $index'),
        ),
      ),
    );
  }
}

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key, required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product details'),
      ),
      body: Center(
        child: Text('Product $productId'),
      ),
    );
  }
}

class TabsScreen extends StatelessWidget {
  final Map<String, String> pathParams;
  final Map<String, String> queryParams;

  const TabsScreen(
      {super.key, required this.pathParams, required this.queryParams});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tabs'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Tab 1'),
              Tab(text: 'Tab 2'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            WouterLink(path: '/tabs/tab1', label: 'Go to Tab 1'),
            WouterLink(path: '/tabs/tab2', label: 'Go to Tab 2'),
          ],
        ),
      ),
    );
  }
}

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: (value) => setState(() {
            selectedIndex = value;
          }),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favourite',
            )
          ],
        ),
        appBar: AppBar(
          title: const Text('Nav'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Nav 1'),
              Tab(text: 'Nav 2'),
            ],
          ),
        ),
        body: IndexedStack(
          index: selectedIndex,
          children: const [
            WouterLink(path: '/nav/nav1', label: 'Go to Nav 1'),
            WouterLink(path: '/nav/nav2', label: 'Go to Nav 2'),
          ],
        ),
      ),
    );
  }
}

class SearchScreen extends StatelessWidget {
  final Map<String, String> queryParams;

  const SearchScreen({super.key, required this.queryParams});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Search Screen'),
            if (queryParams.isNotEmpty)
              Text(
                  'Query Params: ${queryParams.entries.map((e) => '${e.key}=${e.value}').join(', ')}'),
            const SizedBox(height: 20),
            const WouterLink(path: '/', label: 'Go to Home'),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: authProvider.logIn,
          child: const Text('Login'),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Profile'),
      ),
    );
  }
}

class WouterLink extends StatelessWidget {
  final String path;
  final String label;

  const WouterLink({super.key, required this.path, required this.label});

  @override
  Widget build(BuildContext context) {
    final routerDelegate =
        Router.of(context).routerDelegate as WouterRouterDelegate;

    return GestureDetector(
      onTap: () {
        routerDelegate.navigateTo(path);
      },
      child: Text(
        label,
        style: const TextStyle(
            color: Colors.blue, decoration: TextDecoration.underline),
      ),
    );
  }
}

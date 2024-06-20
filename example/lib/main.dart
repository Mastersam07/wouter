import 'package:flutter/material.dart';

import 'navigation/router.dart';

const bool isloggedIn = false;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int? selectedProduct;
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerDelegate: routerDelegate,
      routeInformationParser: routeInformationParser,
      // home: Navigator(
      //   onPopPage: (route, result) {
      //     final page = route.settings as MaterialPage;
      //     if (page.key == ProductView.valueKey) {
      //       selectedProduct = null;
      //     }
      //     return route.didPop(result);
      //   },
      //   pages: [
      //     MaterialPage(
      //       child: ProductListingView(
      //         didSelectProduct: selectProduct,
      //       ),
      //     ),
      //     if (selectedProduct != null)
      //       MaterialPage(
      //         key: ProductView.valueKey,
      //         child: ProductView(productIndex: selectedProduct!),
      //       ),
      //   ],
      // ),
    );
  }

  selectProduct(product) {
    setState(() {
      selectedProduct = product;
    });
  }
}

class ProductListingView extends StatelessWidget {
  const ProductListingView({super.key, this.didSelectProduct});

  final Function(int product)? didSelectProduct;

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
          onTap: () => didSelectProduct?.call(index),
          title: Text('Product $index'),
        ),
      ),
    );
  }
}

class ProductView extends StatelessWidget {
  const ProductView({super.key, required this.productIndex});

  static const valueKey = ValueKey('ProductView');

  final int productIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product details'),
      ),
      body: Center(
        child: Text('Product $productIndex'),
      ),
    );
  }
}

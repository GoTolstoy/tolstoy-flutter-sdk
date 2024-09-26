import 'package:flutter/material.dart';

import 'package:tolstoy_flutter_sdk/modules/products/models.dart';

import 'package:tolstoy_flutter_sdk/modules/api/widgets.dart'; // export TvConfigProvider from here
import 'package:tolstoy_flutter_sdk/modules/rail/widgets.dart'; // export rail and rail_with_feed from here
import 'package:tolstoy_flutter_sdk/modules/feed/screens.dart'; // export feed from here
import 'package:tolstoy_flutter_sdk/modules/feed/widgets.dart'; // export feed_view from here

final String publishId = '55cudyy8uxyn5';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tolstoy flutter sdk',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          surface: const Color(0xFF323232),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Tolstoy flutter sdk'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // just feed as widget

  // onProductClick(Product product) {
  //   print('product clicked: ${product.title}');
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: FeedScreen(
  //       publishId: publishId,
  //       onProductClick: onProductClick,
  //     ),
  //   );
  // }

  // just rail as widget

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: SafeArea(
  //       child: TvConfigProvider(
  //         publishId: publishId,
  //         builder: (context, config) {
  //           return Column(
  //             children: [
  //               Rail(
  //                 config: config,
  //                 onAssetClick: (asset) {
  //                   // Handle asset click
  //                   print('Asset clicked: ${asset.name}');
  //                 },
  //               ),
  //               // Add more widgets here if needed
  //             ],
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  // rail with feed (all in one)

  void onProductClick(Product product) {
    print('product clicked: ${product.title}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RailWithFeed(
          publishId: publishId,
          onProductClick: onProductClick,
        ),
      ),
    );
  }
}

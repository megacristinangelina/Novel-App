import 'package:flutter/material.dart';
import 'package:flutter_pos/presentation/item_type_list/item_type_index_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 82, 56, 128),
          foregroundColor: Colors.white,
        ),
      ),
      home: const MyHomePage(title: 'Novel Catalog'),
    );
  }
}

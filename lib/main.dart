import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'homepage.dart';
// https://www.youtube.com/watch?v=mMgr47QBZWA

Future<void> main() async {
  await Hive.initFlutter();
  /// open a box
  var box = await Hive.openBox('mybox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

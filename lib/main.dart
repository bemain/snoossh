import 'package:flutter/material.dart';
import 'package:snoossh/background.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Background.initialize();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}

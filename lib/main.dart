import 'package:flutter/material.dart';
import 'package:snoossh/background.dart';
import 'package:snoossh/home.dart';
import 'package:snoossh/persistent_value.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Background.initialize();
  await PersistentValue.initialize();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData.light(useMaterial3: true)
          .copyWith(sliderTheme: SliderThemeData(year2023: false)),
    );
  }
}

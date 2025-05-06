import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/play.dart';

void main() {
  runApp(BrainBattleApp());
}

class BrainBattleApp extends StatefulWidget {
  @override
  _BrainBattleAppState createState() => _BrainBattleAppState();
}

class _BrainBattleAppState extends State<BrainBattleApp> {
  bool isDarkTheme = false;

  void toggleTheme(bool value) {
    setState(() {
      isDarkTheme = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrainBattle',
      debugShowCheckedModeBanner: false,
      theme: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: HomeScreen(toggleTheme: toggleTheme, isDarkTheme: isDarkTheme),
      routes: {
        '/play': (context) => PlayScreen(),
      },
    );
  }
}

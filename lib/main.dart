import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/play.dart';
import 'pages/register.dart';

void main() {
  runApp(BrainBattleApp());
}

class BrainBattleApp extends StatefulWidget {
  @override
  _BrainBattleAppState createState() => _BrainBattleAppState();
}

class _BrainBattleAppState extends State<BrainBattleApp> {
  bool isDarkTheme = true; // Cambiado a true para que el modo oscuro sea el predeterminado

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
        '/register': (context) => RegisterScreen(
          isDarkTheme: isDarkTheme,
          toggleTheme: toggleTheme,
        ),
      },
    );
  }
}

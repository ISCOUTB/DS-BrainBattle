import 'package:flutter/material.dart';
import 'pages/loading.dart';
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

  Future<void> _simulateLoading() async {
    // Simula un tiempo de carga de 5 segundos
    await Future.delayed(Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _simulateLoading(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra la pantalla de carga mientras se espera
          return MaterialApp(
            title: 'BrainBattle',
            debugShowCheckedModeBanner: false,
            theme: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
            home: LoadingScreen(),
          );
        } else {
          // Muestra la pantalla principal después de la carga
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
      },
    );
  }
}

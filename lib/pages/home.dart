import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart'; // Para rootBundle
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// Cambiar HomeScreen a StatefulWidget
class HomeScreen extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDarkTheme;

  const HomeScreen({
    Key? key,
    required this.toggleTheme,
    required this.isDarkTheme,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController userController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    userController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<String> _getUserData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final file = File('$path/users.json');
      List allUsers = [];
      if (await file.exists()) {
        final localData = await file.readAsString();
        final localUsers = (jsonDecode(localData)['users'] as List?) ?? [];
        allUsers.addAll(localUsers);
      }
      // Siempre agregar los usuarios de assets
      final data1 = await rootBundle.loadString('assets/users.json');
      final data2 = await rootBundle.loadString('assets/users2.json');
      final users1 = (jsonDecode(data1)['users'] as List?) ?? [];
      final users2 = (jsonDecode(data2)['users'] as List?) ?? [];
      allUsers.addAll(users1);
      allUsers.addAll(users2);
      // Eliminar duplicados por username (el último sobreescribe)
      final uniqueUsers = {for (var u in allUsers) u['username']: u}.values.toList();
      return jsonEncode({'users': uniqueUsers});
    } catch (e) {
      // Si hay error, intenta solo con users.json
      return await rootBundle.loadString('assets/users.json');
    }
  }

  Future<void> _login(BuildContext context, String username, String password) async {
    try {
      final String data = await _getUserData();
      final Map<String, dynamic> jsonResult = jsonDecode(data);
      final List users = jsonResult['users'];
      final user = users.firstWhere(
        (u) =>
          (u['username']?.toString().trim().toLowerCase() ?? '') == username.trim().toLowerCase() &&
          (u['password']?.toString().trim().toLowerCase() ?? '') == password.trim().toLowerCase(),
        orElse: () => null,
      );
      if (user != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Éxito'),
              content: Text('Inicio de sesión exitoso'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/play');
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Credenciales incorrectas'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error de conexión'),
            content: Text('Error: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            '',
            style: TextStyle(
              fontStyle: FontStyle.italic, // Fuente cursiva
              fontWeight: FontWeight.bold, // Fuente más gruesa
              fontSize: 50, // Tamaño de fuente más grande
              fontFamily: 'Georgia', // Fuente elegante
            ),
          ),
        ),
        actions: [
          Switch(
            value: widget.isDarkTheme,
            onChanged: widget.toggleTheme,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Imagen de fondo móvil (superpuesta, con opacidad)
          Positioned.fill(
            child: Image.asset(
              'assets/usu-contra-movil.jpeg',
              fit: BoxFit.contain,
              alignment: Alignment.center,
              opacity: AlwaysStoppedAnimation(0.85),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '',
                    style: TextStyle(
                      fontSize: 32, // Tamaño de fuente más grande
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: widget.isDarkTheme ? Colors.grey[900] : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: widget.isDarkTheme ? Colors.black54 : Colors.grey,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      width: MediaQuery.of(context).size.width < 500
                          ? MediaQuery.of(context).size.width * 0.9
                          : MediaQuery.of(context).size.width * 0.3,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: userController,
                            decoration: InputDecoration(
                              labelText: 'Usuario',
                              labelStyle: TextStyle(
                                color: widget.isDarkTheme ? Colors.white : Colors.black,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: widget.isDarkTheme ? Colors.white : Colors.black,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: widget.isDarkTheme ? Colors.blue : Colors.blueAccent,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            ),
                            style: TextStyle(
                              color: widget.isDarkTheme ? Colors.white : Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 16),
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              labelStyle: TextStyle(
                                color: widget.isDarkTheme ? Colors.white : Colors.black,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: widget.isDarkTheme ? Colors.white : Colors.black,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: widget.isDarkTheme ? Colors.blue : Colors.blueAccent,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            ),
                            style: TextStyle(
                              color: widget.isDarkTheme ? Colors.white : Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: widget.isDarkTheme ? Colors.grey[800] : Colors.blue,
                              ),
                              onPressed: () {
                                if (userController.text.isEmpty || passwordController.text.isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Error'),
                                        content: Text('Por favor, ingrese usuario y contraseña'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  _login(context, userController.text, passwordController.text);
                                }
                              },
                              child: Text(
                                'Jugar',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Roboto',
                                  color: widget.isDarkTheme ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: MediaQuery.of(context).size.width < 500
                        ? MediaQuery.of(context).size.width * 0.9
                        : MediaQuery.of(context).size.width * 0.3,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: widget.isDarkTheme ? Colors.grey[800] : Colors.blue,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text(
                        'Registrarse',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Roboto',
                          color: widget.isDarkTheme ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 40, // Botón más grande
                        icon: Icon(Icons.facebook, color: Colors.white),
                        onPressed: () {},
                      ),
                      SizedBox(width: 20),
                      IconButton(
                        iconSize: 40, // Botón más grande
                        icon: Icon(Icons.apple, color: Colors.white),
                        onPressed: () {},
                      ),
                      SizedBox(width: 20),
                      IconButton(
                        iconSize: 40, // Botón más grande
                        icon: Icon(Icons.g_mobiledata, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
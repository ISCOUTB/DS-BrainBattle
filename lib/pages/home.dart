import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  final Function(bool) toggleTheme;
  final bool isDarkTheme;

  const HomeScreen({
    Key? key,
    required this.toggleTheme,
    required this.isDarkTheme,
  }) : super(key: key);

  Future<void> _login(BuildContext context, String username, String password) async {
    final url = Uri.parse('http://localhost:8000/api/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
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
                    Navigator.pushNamed(context, '/play'); // Navegar a play.dart
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
            content: Text('Error de conexión: $e'),
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
    TextEditingController userController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

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
            value: isDarkTheme,
            onChanged: toggleTheme,
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/usu-contra.jpeg'),
            fit: BoxFit.contain,
            alignment: Alignment.center,
          ),
        ),
        child: Center(
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
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDarkTheme ? Colors.grey[900] : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: isDarkTheme ? Colors.black54 : Colors.grey,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width * 0.3, // Reducir el ancho del login
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: userController,
                        decoration: InputDecoration(
                          labelText: 'Usuario',
                          labelStyle: TextStyle(
                            color: isDarkTheme ? Colors.white : Colors.black,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: isDarkTheme ? Colors.white : Colors.black,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: isDarkTheme ? Colors.blue : Colors.blueAccent,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          color: isDarkTheme ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          labelStyle: TextStyle(
                            color: isDarkTheme ? Colors.white : Colors.black,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: isDarkTheme ? Colors.white : Colors.black,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: isDarkTheme ? Colors.blue : Colors.blueAccent,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          color: isDarkTheme ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Bordes menos redondeados
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20), // Tamaño uniforme
                          backgroundColor: isDarkTheme ? Colors.grey[800] : Colors.blue,
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
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Roboto',
                            color: isDarkTheme ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Bordes menos redondeados
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20), // Tamaño uniforme
                  backgroundColor: isDarkTheme ? Colors.grey[800] : Colors.blue, // Cambia el color dependiendo del tema
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text(
                  'Registrarse',
                  style: TextStyle(
                    fontSize: 20, // Fuente más grande
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                    color: isDarkTheme ? Colors.white : Colors.black, // Cambia el color dependiendo del tema
                  ),
                ),
              ),
              SizedBox(height: 20),
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
            ],
          ),
        ),
      ),
    );
  }
}
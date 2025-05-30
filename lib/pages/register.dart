import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart'; // Para rootBundle
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class RegisterScreen extends StatefulWidget {
  final bool isDarkTheme;
  final Function(bool) toggleTheme;

  RegisterScreen({
    required this.isDarkTheme,
    required this.toggleTheme,
  });

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isValidUsername(String username) {
    final regex = RegExp(r'^[a-zA-Z0-9]+$');
    return regex.hasMatch(username);
  }

  Future<File> _getLocalUserFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/users.json');
    if (!(await file.exists())) {
      // Copia el archivo de assets la primera vez
      String data;
      try {
        data = await rootBundle.loadString('assets/users.json');
      } catch (e) {
        data = await rootBundle.loadString('assets/users2.json');
      }
      await file.writeAsString(data);
    }
    return file;
  }

  Future<void> _register() async {
    if (kIsWeb) {
      await _registerWeb();
      return;
    }
    if (_formKey.currentState!.validate()) {
      try {
        final file = await _getLocalUserFile();
        final String data = await file.readAsString();
        Map<String, dynamic> jsonResult = {};
        List users = [];
        try {
          jsonResult = jsonDecode(data);
          users = jsonResult['users'] ?? [];
        } catch (e) {
          users = [];
        }
        final exists = users.any((u) => (u['username'] ?? '') == _usernameController.text);
        if (exists) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('El usuario ya existe'),
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
          // Agrega el nuevo usuario
          users.add({
            'username': _usernameController.text,
            'password': _passwordController.text,
          });
          await file.writeAsString(jsonEncode({'users': users}));
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Éxito'),
                content: Text('Registro exitoso'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacementNamed(context, '/');
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
  }

  Future<void> _registerWeb() async {
    // Solo simula el registro en web, sin persistencia
    final String data = await rootBundle.loadString('assets/users.json');
    final Map<String, dynamic> jsonResult = jsonDecode(data);
    final List users = jsonResult['users'];
    final exists = users.any((u) => u['username'] == _usernameController.text);
    if (exists) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Registro exitoso'),
            content: Text('Registro Exitoso!'),
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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Éxito'),
            content: Text('Registro exitoso '),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, '/');
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
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            '',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 50,
              fontFamily: 'Georgia',
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
          // Imagen de fondo web
          Positioned.fill(
            child: Image.asset(
              'assets/registro.jpeg',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          // Imagen de fondo móvil (superpuesta, con opacidad)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/registro-movil.jpeg'),
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.isDarkTheme
                    ? Colors.grey[900]?.withOpacity(0.9)
                    : Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: widget.isDarkTheme ? Colors.black54 : Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              width: MediaQuery.of(context).size.width * 0.5,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Correo Electrónico',
                        labelStyle: TextStyle(
                          color: widget.isDarkTheme ? Colors.white : Colors.black,
                        ),
                      ),
                      style: TextStyle(
                        color: widget.isDarkTheme ? Colors.white : Colors.black,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su correo electrónico';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Por favor ingrese un correo válido';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        labelText: 'Primer Nombre',
                        labelStyle: TextStyle(
                          color: widget.isDarkTheme ? Colors.white : Colors.black,
                        ),
                      ),
                      style: TextStyle(
                        color: widget.isDarkTheme ? Colors.white : Colors.black,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su primer nombre';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        labelText: 'Primer Apellido',
                        labelStyle: TextStyle(
                          color: widget.isDarkTheme ? Colors.white : Colors.black,
                        ),
                      ),
                      style: TextStyle(
                        color: widget.isDarkTheme ? Colors.white : Colors.black,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su primer apellido';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Usuario',
                        labelStyle: TextStyle(
                          color: widget.isDarkTheme ? Colors.white : Colors.black,
                        ),
                      ),
                      style: TextStyle(
                        color: widget.isDarkTheme ? Colors.white : Colors.black,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese un usuario';
                        } else if (!_isValidUsername(value)) {
                          return 'El usuario no debe contener caracteres especiales';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        labelStyle: TextStyle(
                          color: widget.isDarkTheme ? Colors.white : Colors.black,
                        ),
                      ),
                      style: TextStyle(
                        color: widget.isDarkTheme ? Colors.white : Colors.black,
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese una contraseña';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 20),
                          backgroundColor:
                              widget.isDarkTheme ? Colors.grey[800] : Colors.blue,
                        ),
                        onPressed: _register,
                        child: Text(
                          'Registrar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Roboto',
                            color:
                                widget.isDarkTheme ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final Function(bool) toggleTheme;
  final bool isDarkTheme;

  const HomeScreen({
    Key? key,
    required this.toggleTheme,
    required this.isDarkTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'brainbattle',
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/home.jpg'),
            fit: BoxFit.cover, // Ajusta la imagen para cubrir todo el fondo
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '¡Bienvenido a brainbattle!',
                style: TextStyle(
                  fontSize: 32, // Tamaño de fuente más grande
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Forma de rectángulo redondeado
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20), // Botón más grande
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/play');
                },
                child: Text(
                  'Jugar',
                  style: TextStyle(
                    fontSize: 20, // Fuente más grande
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                    color: Colors.white, // Letra blanca
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
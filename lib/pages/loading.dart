import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, // Asegura que el contenedor cubra todo el ancho
        height: double.infinity, // Asegura que el contenedor cubra todo el alto
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/play.jpg'), // Imagen de fondo
            fit: BoxFit.cover, // Ajustar la imagen para cubrir todo el fondo
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // El indicador de carga
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Color blanco para el indicador
            ),
            SizedBox(height: 250), // Espaciado
            // El texto de carga
            Text(
              'Loading...',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Color del texto blanco
                fontFamily: 'Roboto', // Fuente del texto
              ),
            ),
          ],
        ),
      ),
    );
  }
}
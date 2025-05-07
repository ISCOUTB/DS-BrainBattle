import 'package:flutter/material.dart';
import '../categorias/questions.dart';

class PlayScreen extends StatefulWidget {
  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  String? selectedCategory;

  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void resetCategory() {
    setState(() {
      selectedCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Play BrainBattle',
            style: TextStyle(
              fontStyle: FontStyle.italic, // Fuente cursiva
              fontWeight: FontWeight.bold, // Fuente más gruesa
              fontSize: 50, // Tamaño de fuente más grande
              fontFamily: 'Georgia', // Fuente elegante
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/play.jpg'), // Imagen de fondo
            fit: BoxFit.cover, // Ajustar la imagen para cubrir todo el fondo
          ),
          gradient: LinearGradient(
            colors: [
              Colors.red.withOpacity(0.5), // Historia con opacidad
              Colors.blue.withOpacity(0.5), // Inglés con opacidad
              Colors.green.withOpacity(0.5), // Matemáticas con opacidad
              Colors.orange.withOpacity(0.5), // Ciencias Naturales con opacidad
              Colors.purple.withOpacity(0.5), // Informática con opacidad
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: selectedCategory == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    'Historia', 'Inglés', 'Matemáticas', 'Ciencias Naturales', 'Informática'
                  ].asMap().entries.map((entry) {
                    final index = entry.key;
                    final category = entry.value;
                    final colors = [
                      Colors.red, // Historia
                      Colors.blue, // Inglés
                      Colors.green, // Matemáticas
                      Colors.orange, // Ciencias Naturales
                      Colors.purple, // Informática
                    ];
                    return SizedBox(
                      width: 200, // Ancho fijo para todos los botones
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                          onPressed: () => selectCategory(category),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors[index], // Color correspondiente
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 20),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Roboto',
                              color: Colors.black, // Color del texto cambiado a negro
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )
              : QuestionsScreen(
                  category: selectedCategory!,
                  onBack: resetCategory,
                ),
        ),
      ),
    );
  }
}
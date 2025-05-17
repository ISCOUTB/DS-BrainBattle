import 'package:flutter/material.dart';
import '../categorias/questions.dart';
import 'usuario.dart';

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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Centrar el título
          children: [
            Text(
              '',
              style: TextStyle(
                fontStyle: FontStyle.italic, // Fuente cursiva
                fontWeight: FontWeight.bold, // Fuente más gruesa
                fontSize: 50, // Tamaño de fuente más grande
                fontFamily: 'Georgia', // Fuente elegante
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/categorias.jpg'), // Cambiar por imagen seleccionada
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UsuarioScreen(
                    nombre: 'Nombre',
                    apellido: 'Apellido',
                    usuario: 'Usuario',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/categorias.jpeg'),
            fit: BoxFit.contain,
            alignment: Alignment.center,
          ),
        ),
        child: Center(
          child: selectedCategory == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Spacer(), // Empuja los botones hacia el final de la página
                    ...['Historia', 'Inglés', 'Matemáticas', 'Ciencias Naturales', 'Informática']
                      .asMap()
                      .entries
                      .map((entry) {
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
                      })
                      .toList(),
                  SizedBox(height: 60), // Espacio para que los botones no queden tan pegados al borde inferior
                ],
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
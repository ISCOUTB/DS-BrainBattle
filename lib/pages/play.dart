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
      body: Stack(
        children: [
          // Imagen de fondo móvil que cubre todo el celular
          Positioned.fill(
            child: Image.asset(
              'assets/categorias-movil.jpeg',
              fit: BoxFit.cover, // Ocupa todo el fondo
              alignment: Alignment.center,
            ),
          ),
          Center(
            child: selectedCategory == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Spacer(),
                      SizedBox(height: 40), // Deja espacio para el título de la imagen
                      ...['Historia', 'Ingles', 'Matematicas', 'Ciencias Naturales', 'Informatica']
                        .asMap()
                        .entries
                        .map((entry) {
                          final index = entry.key;
                          final category = entry.value;
                          final colors = [
                            Colors.red,
                            Colors.blue,
                            Colors.green,
                            Colors.orange,
                            Colors.purple,
                          ];
                          return SizedBox(
                            width: 200,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: ElevatedButton(
                                onPressed: () => selectCategory(category),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colors[index],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                ),
                                child: Text(
                                  category,
                                  style: TextStyle(
                                    fontSize: 18, // Más grande
                                    fontWeight: FontWeight.bold, // Negrita
                                    fontFamily: 'Roboto',
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
                        .toList(),
                      SizedBox(height: 60),
                    ],
                  )
                : QuestionsScreen(
                    category: selectedCategory!,
                    onBack: resetCategory,
                  ),
          ),
        ],
      ),
    );
  }
}

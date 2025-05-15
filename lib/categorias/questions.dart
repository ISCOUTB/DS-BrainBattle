import 'package:flutter/material.dart';
import '../services/api_service.dart';

class Gestor {
  static Future<List<Map<String, dynamic>>> getQuestionsForCategory(String category) async {
    final allQuestions = await ApiService.fetchPreguntas();
    return allQuestions.where((q) => q['categoria'] == category).toList();
  }
}

class QuestionsScreen extends StatefulWidget {
  final String category;
  final VoidCallback onBack;

  QuestionsScreen({required this.category, required this.onBack});

  @override
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  int _currentQuestionIndex = 0;
  bool? _isCorrect;
  late Future<List<Map<String, dynamic>>> _questionsFuture;

  @override
  void initState() {
    super.initState();
    _questionsFuture = Gestor.getQuestionsForCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _questionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error al cargar preguntas'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay preguntas disponibles'));
        }

        final questions = snapshot.data!;
        final currentQuestion = questions[_currentQuestionIndex];

        // Selección dinámica del fondo según la categoría
        String backgroundImage;
        switch (widget.category) {
          case 'Historia':
            backgroundImage = 'assets/historia.jpg';
            break;
          case 'Inglés':
            backgroundImage = 'assets/ingles.jpg';
            break;
          case 'Matemáticas':
            backgroundImage = 'assets/mate.jpg';
            break;
          case 'Ciencias Naturales':
            backgroundImage = 'assets/biologia.jpg';
            break;
          case 'Informática':
            backgroundImage = 'assets/info.jpg';
            break;
          default:
            backgroundImage = 'assets/questions.jpg';
        }

        // Construir las opciones a partir del modelo de la base de datos, robusto a diferentes nombres de campos
        List<String> options = [];
        if (currentQuestion['options'] != null && currentQuestion['options'] is List) {
          options = List<String>.from(currentQuestion['options']);
        } else {
          String getField(Map<String, dynamic> q, List<String> keys) {
            for (final k in keys) {
              if (q[k] != null && q[k].toString().isNotEmpty) return q[k].toString();
            }
            return '';
          }
          options = [
            getField(currentQuestion, ['correctAnswer', 'RespuestaCorrecta', 'respuestacorrecta']),
            getField(currentQuestion, ['RespuestaIncorrecta1', 'respuestaIncorrecta1', 'respuestaincorrecta1']),
            getField(currentQuestion, ['RespuestaIncorrecta2', 'respuestaIncorrecta2', 'respuestaincorrecta2']),
            getField(currentQuestion, ['RespuestaIncorrecta3', 'respuestaIncorrecta3', 'respuestaincorrecta3']),
          ];
        }
        options.removeWhere((element) => element.isEmpty);
        options.shuffle();

        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(backgroundImage),
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    currentQuestion['question'] ?? currentQuestion['Enunciado'] ?? '',
                    style: TextStyle(fontSize: 32, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                Column(
                  children: options.map((option) {
                    return SizedBox(
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            textStyle: TextStyle(color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 20),
                          ),
                          onPressed: _isCorrect == null
                              ? () {
                                  setState(() {
                                    _isCorrect = option == (currentQuestion['correctAnswer'] ?? currentQuestion['RespuestaCorrecta']);
                                  });
                                  Future.delayed(Duration(seconds: 1), () {
                                    setState(() {
                                      if (_currentQuestionIndex < questions.length - 1) {
                                        _currentQuestionIndex++;
                                        _isCorrect = null;
                                      } else {
                                        widget.onBack();
                                      }
                                    });
                                  });
                                }
                              : null,
                          child: Text(
                            option,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: widget.onBack,
                  child: Text('volver a Categorias'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
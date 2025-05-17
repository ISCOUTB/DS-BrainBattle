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
  int? _selectedIndex; // índice de la opción seleccionada
  late Future<List<Map<String, dynamic>>> _questionsFuture;
  List<String> _shuffledOptions = [];

  @override
  void initState() {
    super.initState();
    _questionsFuture = Gestor.getQuestionsForCategory(widget.category);
  }

  void _prepareOptions(Map<String, dynamic> currentQuestion) {
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
    _shuffledOptions = List<String>.from(options);
    _shuffledOptions.shuffle();
  }

  Color? _getButtonColor(int index, List<String> options, Map<String, dynamic> currentQuestion) {
    if (_selectedIndex == null) return Colors.black;
    final correct = options[index] == (currentQuestion['correctAnswer'] ?? currentQuestion['RespuestaCorrecta']);
    if (index == _selectedIndex) {
      return correct ? Colors.green : Colors.red;
    }
    // Si ya se seleccionó y este botón es la respuesta correcta, mostrar verde
    if (_selectedIndex != null && correct) {
      return Colors.green;
    }
    return Colors.black;
  }

  ButtonStyle _getButtonStyle(int index, List<String> options, Map<String, dynamic> currentQuestion) {
    final color = _getButtonColor(index, options, currentQuestion);
    return ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      disabledBackgroundColor: color, // Para que el color se mantenga aunque esté deshabilitado
      disabledForegroundColor: Colors.white,
      textStyle: TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.symmetric(vertical: 20),
      elevation: 2,
    );
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
            backgroundImage = 'assets/historia.jpeg';
            break;
          case 'Inglés':
            backgroundImage = 'assets/ingles.jpeg';
            break;
          case 'Matemáticas':
            backgroundImage = 'assets/mate.jpeg';
            break;
          case 'Ciencias Naturales':
            backgroundImage = 'assets/biologia.jpeg';
            break;
          case 'Informática':
            backgroundImage = 'assets/info.jpeg';
            break;
          default:
            backgroundImage = 'assets/questions.jpeg';
        }

        // Solo mezclar opciones si es la primera vez que se muestra la pregunta
        if (_shuffledOptions.isEmpty) {
          _prepareOptions(currentQuestion);
        }

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
                  children: List.generate(_shuffledOptions.length, (index) {
                    final option = _shuffledOptions[index];
                    return SizedBox(
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                          style: _getButtonStyle(index, _shuffledOptions, currentQuestion),
                          onPressed: _selectedIndex == null
                              ? () {
                                  setState(() {
                                    _selectedIndex = index;
                                  });
                                  Future.delayed(Duration(seconds: 1), () {
                                    setState(() {
                                      if (_currentQuestionIndex < questions.length - 1) {
                                        _currentQuestionIndex++;
                                        _selectedIndex = null;
                                        _shuffledOptions = [];
                                      } else {
                                        widget.onBack();
                                      }
                                    });
                                  });
                                }
                              : null,
                          child: Text(
                            option,
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  }),
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
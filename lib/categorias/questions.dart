import 'package:flutter/material.dart';
import 'historia.dart';
import 'ingles.dart';
import 'matematicas.dart';
import 'ciencias_naturales.dart';
import 'informatica.dart';

class Gestor {
  static List<Map<String, dynamic>> getQuestionsForCategory(String category) {
    switch (category) {
      case 'Historia':
        return historiaQuestions;
      case 'Inglés':
        return inglesQuestions;
      case 'Matemáticas':
        return matematicasQuestions;
      case 'Ciencias Naturales':
        return cienciasNaturalesQuestions;
      case 'Informática':
        return informaticaQuestions;
      default:
        return [];
    }
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

  @override
  Widget build(BuildContext context) {
    final questions = Gestor.getQuestionsForCategory(widget.category);
    final currentQuestion = questions[_currentQuestionIndex];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white, // Fondo blanco
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // Sombra hacia abajo
              ),
            ],
          ),
          child: Text(
            currentQuestion['question'],
            style: TextStyle(fontSize: 50, color: Colors.black), // Cambiamos el color a negro
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 20),
        Column(
          children: currentQuestion['options'].map<Widget>((option) {
            return SizedBox(
              width: 300, // Ancho fijo para todos los botones
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10), // Espaciado vertical entre botones
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Fondo negro
                    textStyle: TextStyle(color: Colors.white), // Texto blanco
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20), // Tamaño similar a play.dart
                  ),
                  onPressed: _isCorrect == null
                      ? () {
                          setState(() {
                            _isCorrect = option == currentQuestion['correctAnswer'];
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
          child: Text('Back to Categories'),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';

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
    final questions = _getQuestionsForCategory(widget.category);
    final currentQuestion = questions[_currentQuestionIndex];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Category: ${widget.category}',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Text(
          currentQuestion['question'],
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 20),
        ...currentQuestion['options'].map<Widget>((option) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _isCorrect == null
                    ? Colors.black
                    : (option == currentQuestion['correctAnswer']
                        ? Colors.green
                        : Colors.red),
                textStyle: TextStyle(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                padding: EdgeInsets.symmetric(vertical: 20),
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
          );
        }).toList(),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: widget.onBack,
          child: Text('Back to Categories'),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getQuestionsForCategory(String category) {
    switch (category) {
      case 'Historia':
        return [
          {
            'question': '¿Quién descubrió América?',
            'options': ['Cristóbal Colón', 'Simón Bolívar', 'Napoleón', 'Hernán Cortés'],
            'correctAnswer': 'Cristóbal Colón',
          },
          {
            'question': '¿En qué año comenzó la Primera Guerra Mundial?',
            'options': ['1914', '1939', '1812', '1945'],
            'correctAnswer': '1914',
          },
        ];
      case 'Inglés':
        return [
          {
            'question': 'What is the past tense of "go"?',
            'options': ['Went', 'Goed', 'Gone', 'Goes'],
            'correctAnswer': 'Went',
          },
          {
            'question': 'Which word is a synonym for "happy"?',
            'options': ['Sad', 'Joyful', 'Angry', 'Tired'],
            'correctAnswer': 'Joyful',
          },
        ];
      case 'Matemáticas':
        return [
          {
            'question': '¿Cuánto es 2 + 2?',
            'options': ['4', '3', '5', '6'],
            'correctAnswer': '4',
          },
          {
            'question': '¿Cuál es el valor de pi (aproximado)?',
            'options': ['3.14', '2.71', '1.41', '1.61'],
            'correctAnswer': '3.14',
          },
        ];
      case 'Ciencias Naturales':
        return [
          {
            'question': '¿Cuál es el planeta más grande del sistema solar?',
            'options': ['Júpiter', 'Saturno', 'Tierra', 'Marte'],
            'correctAnswer': 'Júpiter',
          },
          {
            'question': '¿Qué gas es esencial para la respiración humana?',
            'options': ['Oxígeno', 'Hidrógeno', 'Nitrógeno', 'Dióxido de carbono'],
            'correctAnswer': 'Oxígeno',
          },
        ];
      case 'Informática':
        return [
          {
            'question': '¿Qué significa CPU?',
            'options': ['Unidad Central de Procesamiento', 'Unidad de Control de Procesos', 'Unidad de Computación Personal', 'Unidad de Procesamiento de Cálculos'],
            'correctAnswer': 'Unidad Central de Procesamiento',
          },
          {
            'question': '¿Qué lenguaje se utiliza para desarrollar aplicaciones Android?',
            'options': ['Java', 'Python', 'C++', 'Ruby'],
            'correctAnswer': 'Java',
          },
        ];
      default:
        return [];
    }
  }
}
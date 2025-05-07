import 'package:flutter/material.dart';

class QuestionsScreen extends StatelessWidget {
  final String category;
  final VoidCallback onBack;

  QuestionsScreen({required this.category, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final questions = _getQuestionsForCategory(category);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Category: $category',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        ...questions.map((question) {
          return Column(
            children: [
              Text(
                question['question'],
                style: TextStyle(fontSize: 18),
              ),
              ...question['options'].map<Widget>((option) {
                return ElevatedButton(
                  onPressed: () {},
                  child: Text(option),
                );
              }).toList(),
              SizedBox(height: 20),
            ],
          );
        }).toList(),
        ElevatedButton(
          onPressed: onBack,
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
          },
          {
            'question': '¿En qué año comenzó la Primera Guerra Mundial?',
            'options': ['1914', '1939', '1812', '1945'],
          },
        ];
      case 'Inglés':
        return [
          {
            'question': 'What is the past tense of "go"?',
            'options': ['Went', 'Goed', 'Gone', 'Goes'],
          },
          {
            'question': 'Which word is a synonym for "happy"?',
            'options': ['Sad', 'Joyful', 'Angry', 'Tired'],
          },
        ];
      case 'Matemáticas':
        return [
          {
            'question': '¿Cuánto es 2 + 2?',
            'options': ['4', '3', '5', '6'],
          },
          {
            'question': '¿Cuál es el valor de pi (aproximado)?',
            'options': ['3.14', '2.71', '1.41', '1.61'],
          },
        ];
      case 'Ciencias Naturales':
        return [
          {
            'question': '¿Cuál es el planeta más grande del sistema solar?',
            'options': ['Júpiter', 'Saturno', 'Tierra', 'Marte'],
          },
          {
            'question': '¿Qué gas es esencial para la respiración humana?',
            'options': ['Oxígeno', 'Hidrógeno', 'Nitrógeno', 'Dióxido de carbono'],
          },
        ];
      case 'Informática':
        return [
          {
            'question': '¿Qué significa CPU?',
            'options': ['Unidad Central de Procesamiento', 'Unidad de Control de Procesos', 'Unidad de Computación Personal', 'Unidad de Procesamiento de Cálculos'],
          },
          {
            'question': '¿Qué lenguaje se utiliza para desarrollar aplicaciones Android?',
            'options': ['Java', 'Python', 'C++', 'Ruby'],
          },
        ];
      default:
        return [];
    }
  }
}
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class UsuarioScreen extends StatefulWidget {
  final String nombre;
  final String apellido;
  final String usuario;
  final File? usuarioImage;

  UsuarioScreen({
    required this.nombre,
    required this.apellido,
    required this.usuario,
    this.usuarioImage,
  });

  @override
  _UsuarioScreenState createState() => _UsuarioScreenState();
}

class Partida {
  final DateTime fecha;
  final int puntaje;
  final Duration duracion;

  Partida({required this.fecha, required this.puntaje, required this.duracion});
}

class _UsuarioScreenState extends State<UsuarioScreen> {
  bool isDarkTheme = true;
  List<Partida> historialPartidas = [
    Partida(fecha: DateTime.now().subtract(Duration(days: 1)), puntaje: 80, duracion: Duration(minutes: 10)),
    Partida(fecha: DateTime.now().subtract(Duration(days: 2)), puntaje: 95, duracion: Duration(minutes: 8)),
  ];

  void toggleTheme(bool value) {
    setState(() {
      isDarkTheme = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil de Usuario'),
        actions: [
          Switch(
            value: isDarkTheme,
            onChanged: toggleTheme,
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/home.jpg'),
            fit: BoxFit.contain,
            alignment: Alignment.center,
          ),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDarkTheme ? Colors.grey[900]?.withOpacity(0.9) : Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: isDarkTheme ? Colors.black54 : Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: widget.usuarioImage != null
                      ? FileImage(widget.usuarioImage!)
                      : AssetImage('assets/home.jpg') as ImageProvider,
                ),
                SizedBox(height: 20),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: widget.nombre,
                        decoration: InputDecoration(
                          labelText: 'Nombre',
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(
                            color: isDarkTheme ? Colors.white : Colors.black,
                          ),
                        ),
                        style: TextStyle(
                          color: isDarkTheme ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        initialValue: widget.apellido,
                        decoration: InputDecoration(
                          labelText: 'Apellido',
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(
                            color: isDarkTheme ? Colors.white : Colors.black,
                          ),
                        ),
                        style: TextStyle(
                          color: isDarkTheme ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        initialValue: widget.usuario,
                        decoration: InputDecoration(
                          labelText: 'Usuario',
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(
                            color: isDarkTheme ? Colors.white : Colors.black,
                          ),
                        ),
                        style: TextStyle(
                          color: isDarkTheme ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text('Historial de Partidas:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDarkTheme ? Colors.white : Colors.black)),
                      SizedBox(height: 10),
                      Container(
                        height: 200,
                        child: ListView.builder(
                          itemCount: historialPartidas.length,
                          itemBuilder: (context, index) {
                            final partida = historialPartidas[index];
                            return Card(
                              color: isDarkTheme ? Colors.grey[800] : Colors.white,
                              child: ListTile(
                                title: Text(
                                  'Fecha: ${DateFormat('dd/MM/yyyy').format(partida.fecha)}',
                                  style: TextStyle(color: isDarkTheme ? Colors.white : Colors.black),
                                ),
                                subtitle: Text(
                                  'Puntaje: ${partida.puntaje} - Duración: ${partida.duracion.inMinutes} min',
                                  style: TextStyle(color: isDarkTheme ? Colors.white70 : Colors.black87),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Detalles de la Partida'),
                                      content: Text('Fecha: ${DateFormat('dd/MM/yyyy').format(partida.fecha)}\nPuntaje: ${partida.puntaje}\nDuración: ${partida.duracion.inMinutes} minutos'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text('Cerrar'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
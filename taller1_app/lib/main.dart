import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taller 1',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variable de estado para el título
  String _titulo = 'Hola, Flutter';

  void _cambiarTitulo() {
    setState(() {
      if (_titulo == 'Hola, Flutter') {
        _titulo = '¡Título cambiado!';
      } else {
        _titulo = 'Hola, Flutter';
      }
    });

    // Mostrar SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Título actualizado'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titulo),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Nombre del estudiante
              const SizedBox(height: 16),
              const Text(
                'David Mora Duque',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 24),

              // Imágenes en Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Imagen de internet
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      'https://cdn.conmebol.com/wp-content/uploads/2015/11/messi-clasico-4.jpg',
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Imagen local
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'lib/assets/Messi.jpg',
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Botón para cambiar título
              ElevatedButton(
                onPressed: _cambiarTitulo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text('Cambiar Título'),
              ),

              const SizedBox(height: 24),

              // Widget adicional 1: Container decorado
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.deepPurple),
                ),
                child: const Text(
                  '🎓 Widget adicional: Container\nEste es un contenedor con bordes y color de fondo.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ),

              const SizedBox(height: 24),

              // Widget adicional 2: ListView
              const Text(
                'Widget adicional: ListView',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: ListView(
                  children: const [
                    ListTile(
                      leading: Icon(Icons.star, color: Colors.deepPurple),
                      title: Text('Elemento 1'),
                    ),
                    ListTile(
                      leading: Icon(Icons.favorite, color: Colors.red),
                      title: Text('Elemento 2'),
                    ),
                    ListTile(
                      leading: Icon(Icons.sports_soccer, color: Colors.green),
                      title: Text('Elemento 3'),
                    ),
                    ListTile(
                      leading: Icon(Icons.music_note, color: Colors.orange),
                      title: Text('Elemento 4'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

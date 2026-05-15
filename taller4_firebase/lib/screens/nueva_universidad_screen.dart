import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/universidad.dart';

class NuevaUniversidadScreen extends StatefulWidget {
  const NuevaUniversidadScreen({super.key});
  @override
  NuevaUniversidadScreenState createState() => NuevaUniversidadScreenState();
}

class NuevaUniversidadScreenState extends State<NuevaUniversidadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestoreService = FirestoreService();

  final TextEditingController _nitController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _paginaWebController = TextEditingController();

  // Función para validar URL
  String? _validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'La página web es requerida';
    }
    final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      return 'Ingresa una URL válida';
    }
    return null;
  }

  // Función para guardar
  void _saveUniversidad() async {
    if (_formKey.currentState!.validate()) {
      Universidad universidad = Universidad(
        nit: _nitController.text,
        nombre: _nombreController.text,
        direccion: _direccionController.text,
        telefono: _telefonoController.text,
        paginaWeb: _paginaWebController.text,
      );

      try {
        await _firestoreService.addUniversidad(universidad);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Universidad agregada exitosamente')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al agregar universidad: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nueva Universidad'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nitController,
                decoration: InputDecoration(labelText: 'NIT'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El NIT es requerido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre es requerido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _direccionController,
                decoration: InputDecoration(labelText: 'Dirección'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La dirección es requerida';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefonoController,
                decoration: InputDecoration(labelText: 'Teléfono'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El teléfono es requerido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _paginaWebController,
                decoration: InputDecoration(labelText: 'Página Web'),
                validator: _validateUrl,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveUniversidad,
                child: Text('Guardar Universidad'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nitController.dispose();
    _nombreController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    _paginaWebController.dispose();
    super.dispose();
  }
}
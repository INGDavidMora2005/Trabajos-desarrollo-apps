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
        title: const Text('Nueva Universidad'),
        backgroundColor: const Color(0xFF1A365D),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nitController,
                decoration: const InputDecoration(
                  labelText: 'NIT',
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El NIT es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  prefixIcon: Icon(Icons.business),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _direccionController,
                decoration: const InputDecoration(
                  labelText: 'Dirección',
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La dirección es requerida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telefonoController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El teléfono es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _paginaWebController,
                decoration: const InputDecoration(
                  labelText: 'Página Web',
                  prefixIcon: Icon(Icons.language),
                ),
                validator: _validateUrl,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _saveUniversidad,
                icon: const Icon(Icons.save),
                label: const Text('Guardar Universidad'),
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
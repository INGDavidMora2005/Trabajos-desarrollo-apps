import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/universidad.dart';
import 'nueva_universidad_screen.dart';

class UniversidadesListScreen extends StatelessWidget {
  UniversidadesListScreen({super.key});
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado de Universidades'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NuevaUniversidadScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Universidad>>(
        stream: _firestoreService.getUniversidades(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          List<Universidad> universidades = snapshot.data ?? [];
          return ListView.builder(
            itemCount: universidades.length,
            itemBuilder: (context, index) {
              Universidad universidad = universidades[index];
              return Card(
                child: ListTile(
                  title: Text(universidad.nombre),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('NIT: ${universidad.nit}'),
                      Text('Dirección: ${universidad.direccion}'),
                      Text('Teléfono: ${universidad.telefono}'),
                      Text('Página web: ${universidad.paginaWeb}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
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
        title: const Text('Listado de Universidades'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
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
                  contentPadding: const EdgeInsets.all(20),
                  title: Text(
                    universidad.nombre,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A365D),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(Icons.badge, 'NIT', universidad.nit),
                        _buildInfoRow(Icons.location_on, 'Dirección', universidad.direccion),
                        _buildInfoRow(Icons.phone, 'Teléfono', universidad.telefono),
                        _buildInfoRow(Icons.language, 'Web', universidad.paginaWeb),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF0BC5EA)),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A5568),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Color(0xFF2D3748)),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taller3_jwt/features/auth/presentation/providers/auth_provider.dart';
import 'package:taller3_jwt/core/storage/preferences_service.dart';
import 'package:taller3_jwt/core/storage/secure_storage_service.dart';
import 'package:taller3_jwt/features/auth/presentation/screens/login_screen.dart';

/// Pantalla que muestra evidencia del almacenamiento de datos
class StorageEvidenceScreen extends StatefulWidget {
  const StorageEvidenceScreen({super.key});

  @override
  State<StorageEvidenceScreen> createState() => _StorageEvidenceScreenState();
}

class _StorageEvidenceScreenState extends State<StorageEvidenceScreen> {
  Map<String, String?> _userInfo = {};
  bool _hasToken = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final preferencesService = PreferencesService();
    final secureStorageService = SecureStorageService();

    final userInfo = await preferencesService.getUserInfo();
    final hasToken = await secureStorageService.hasToken();

    setState(() {
      _userInfo = userInfo;
      _hasToken = hasToken;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evidencia de Almacenamiento'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Card 1: Datos del Usuario (SharedPreferences)
            Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.person, color: Colors.blue),
                        SizedBox(width: 8.0),
                        Text(
                          'Datos del Usuario (SharedPreferences)',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        const Icon(Icons.person_outline),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            'Nombre: ${_userInfo['name'] ?? 'No disponible'}',
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        const Icon(Icons.email),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            'Correo: ${_userInfo['email'] ?? 'No disponible'}',
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            'Fecha de login: ${_userInfo['loginDate'] != null ? DateTime.parse(_userInfo['loginDate']!).toLocal().toString() : 'No disponible'}',
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Card 2: Seguridad (SecureStorage)
            Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.security, color: Colors.green),
                        SizedBox(width: 8.0),
                        Text(
                          'Seguridad (SecureStorage)',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Chip(
                      label: Text(
                        _hasToken ? '✓ Token de acceso presente' : '✗ Sin token almacenado',
                        style: TextStyle(
                          color: _hasToken ? Colors.white : Colors.black,
                        ),
                      ),
                      backgroundColor: _hasToken ? Colors.green : Colors.red,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Card 3: Información de la Sesión
            const Card(
              elevation: 4.0,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.orange),
                        SizedBox(width: 8.0),
                        Text(
                          'Información de la Sesión',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'SharedPreferences: datos no sensibles del perfil',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'SecureStorage: tokens de autenticación cifrados',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            // Botón de cerrar sesión
            SizedBox(
              width: double.infinity,
              child: Consumer<AuthProvider>(
                builder: (context, authProvider, child) => ElevatedButton(
                  onPressed: () async {
                    await authProvider.logout();
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text('Cerrar sesión'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
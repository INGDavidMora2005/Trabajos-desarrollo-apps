import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:taller3_jwt/features/auth/data/models/user_model.dart';
import 'package:taller3_jwt/core/storage/preferences_service.dart';
import 'package:taller3_jwt/core/storage/secure_storage_service.dart';

/// Servicio para manejar autenticación con la API
class AuthService {
  final String baseUrl = 'https://parking.visiontic.com.co/api';
  final PreferencesService _preferencesService = PreferencesService();
  final SecureStorageService _secureStorageService = SecureStorageService();

  /// Realiza el login del usuario
  Future<UserModel> login({required String email, required String password}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Adaptar según la estructura real del JSON de login exitoso
        final userModel = UserModel.fromJson(data['user'] ?? data['data']['user']);
        await _secureStorageService.saveTokens(
          accessToken: data['token'] ?? data['access_token'] ?? data['data']['token'],
        );
        await _preferencesService.saveUserInfo(
          name: userModel.name,
          email: userModel.email,
        );
        return userModel;
      } else if (response.statusCode == 401) {
        throw Exception('Credenciales incorrectas');
      } else if (response.statusCode == 422) {
        throw Exception('Datos inválidos. Revisa email y contraseña');
      } else {
        throw Exception(data['message'] ?? 'Error del servidor. Intenta más tarde');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error de conexión: $e');
    }
  }

  /// Registra un nuevo usuario — endpoint correcto: POST /api/users
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users'), // ← CORREGIDO: era /register
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          // Sin password_confirmation — la API no lo pide
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Registro exitoso
        return;
      } else if (response.statusCode == 422) {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'El correo ya está registrado o datos inválidos');
      } else {
        throw Exception('Error al registrar usuario. Intenta más tarde');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error de conexión: $e');
    }
  }
}
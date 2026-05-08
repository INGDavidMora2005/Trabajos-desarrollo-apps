import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Servicio para manejar datos sensibles usando FlutterSecureStorage
class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Guarda los tokens de autenticación
  Future<void> saveTokens({required String accessToken, String? refreshToken}) async {
    try {
      await _storage.write(key: 'accessToken', value: accessToken);
      if (refreshToken != null) {
        await _storage.write(key: 'refreshToken', value: refreshToken);
      }
    } catch (e) {
      throw Exception('Error al guardar tokens: $e');
    }
  }

  /// Obtiene el token de acceso
  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: 'accessToken');
    } catch (e) {
      throw Exception('Error al obtener token de acceso: $e');
    }
  }

  /// Verifica si existe un token de acceso válido
  Future<bool> hasToken() async {
    try {
      final token = await _storage.read(key: 'accessToken');
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Elimina los tokens almacenados
  Future<void> clearTokens() async {
    try {
      await _storage.delete(key: 'accessToken');
      await _storage.delete(key: 'refreshToken');
    } catch (e) {
      throw Exception('Error al eliminar tokens: $e');
    }
  }
}
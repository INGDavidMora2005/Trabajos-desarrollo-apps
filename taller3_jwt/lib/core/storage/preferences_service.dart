import 'package:shared_preferences/shared_preferences.dart';

/// Servicio para manejar datos no sensibles usando SharedPreferences
class PreferencesService {
  /// Guarda la información del usuario después del login
  Future<void> saveUserInfo({required String name, required String email}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', name);
      await prefs.setString('email', email);
      await prefs.setString('loginDate', DateTime.now().toIso8601String());
    } catch (e) {
      throw Exception('Error al guardar información del usuario: $e');
    }
  }

  /// Obtiene la información del usuario almacenada
  Future<Map<String, String?>> getUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('name');
      final email = prefs.getString('email');
      final loginDate = prefs.getString('loginDate');
      return {
        'name': name,
        'email': email,
        'loginDate': loginDate,
      };
    } catch (e) {
      throw Exception('Error al obtener información del usuario: $e');
    }
  }

  /// Elimina la información del usuario almacenada
  Future<void> clearUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('name');
      await prefs.remove('email');
      await prefs.remove('loginDate');
    } catch (e) {
      throw Exception('Error al eliminar información del usuario: $e');
    }
  }
}
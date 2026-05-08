import 'package:flutter/material.dart';
import 'package:taller3_jwt/features/auth/data/services/auth_service.dart';
import 'package:taller3_jwt/features/auth/data/models/user_model.dart';
import 'package:taller3_jwt/core/storage/secure_storage_service.dart';
import 'package:taller3_jwt/core/storage/preferences_service.dart';

/// Estados de autenticación
enum AuthStatus { initial, loading, authenticated, error }

/// Provider para manejar el estado de autenticación
class AuthProvider extends ChangeNotifier {
  AuthStatus status = AuthStatus.initial;
  String? errorMessage;
  UserModel? currentUser;

  final AuthService _authService = AuthService();
  final SecureStorageService _secureStorageService = SecureStorageService();
  final PreferencesService _preferencesService = PreferencesService();

  /// Intenta iniciar sesión con email y contraseña
  Future<void> login(String email, String password) async {
    status = AuthStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.login(email: email, password: password);
      currentUser = user;
      status = AuthStatus.authenticated;
    } catch (e) {
      status = AuthStatus.error;
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    }

    notifyListeners();
  }

  /// Registra un nuevo usuario
  Future<void> register(String name, String email, String password) async {
    status = AuthStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      await _authService.register(name: name, email: email, password: password);
      status = AuthStatus.initial; // Volver al estado inicial después del registro exitoso
      // No autenticar automáticamente, el usuario debe hacer login
    } catch (e) {
      status = AuthStatus.error;
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    }

    notifyListeners();
  }

  /// Cierra la sesión del usuario
  Future<void> logout() async {
    try {
      await _secureStorageService.clearTokens();
      await _preferencesService.clearUserInfo();
      status = AuthStatus.initial;
      currentUser = null;
      errorMessage = null;
      notifyListeners();
    } catch (e) {
      errorMessage = 'Error al cerrar sesión: $e';
      notifyListeners();
    }
  }

  /// Verifica si el usuario está autenticado al iniciar la app
  Future<void> checkAuthStatus() async {
    try {
      final hasToken = await _secureStorageService.hasToken();
      if (hasToken) {
        status = AuthStatus.authenticated;
        // Cargar info del usuario desde preferences si es necesario
        final userInfo = await _preferencesService.getUserInfo();
        if (userInfo['name'] != null && userInfo['email'] != null) {
          currentUser = UserModel(
            name: userInfo['name']!,
            email: userInfo['email']!,
          );
        }
      } else {
        status = AuthStatus.initial;
      }
    } catch (e) {
      status = AuthStatus.error;
      errorMessage = 'Error al verificar autenticación: $e';
    }
    notifyListeners();
  }
}
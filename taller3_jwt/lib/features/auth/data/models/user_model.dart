/// Modelo de datos para el usuario autenticado
class UserModel {
  final int? id;
  final String name;
  final String email;

  UserModel({this.id, required this.name, required this.email});

  /// Crea una instancia de UserModel desde un JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  /// Convierte el modelo a JSON (útil para depuración, no para almacenamiento)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
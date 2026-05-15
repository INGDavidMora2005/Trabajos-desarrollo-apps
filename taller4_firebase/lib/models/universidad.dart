class Universidad {
  final String nit;
  final String nombre;
  final String direccion;
  final String telefono;
  final String paginaWeb;

  Universidad({
    required this.nit,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.paginaWeb,
  });

  // Convertir de Map (Firestore) a Universidad
  factory Universidad.fromMap(Map<String, dynamic> map) {
    return Universidad(
      nit: map['nit'] ?? '',
      nombre: map['nombre'] ?? '',
      direccion: map['direccion'] ?? '',
      telefono: map['telefono'] ?? '',
      paginaWeb: map['pagina_web'] ?? '',
    );
  }

  // Convertir Universidad a Map (para Firestore)
  Map<String, dynamic> toMap() {
    return {
      'nit': nit,
      'nombre': nombre,
      'direccion': direccion,
      'telefono': telefono,
      'pagina_web': paginaWeb,
    };
  }
}
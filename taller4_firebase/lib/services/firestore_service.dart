import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/universidad.dart';

class FirestoreService {
  final CollectionReference universidadesRef =
      FirebaseFirestore.instance.collection('universidades');

  // Crear una nueva universidad
  Future<void> addUniversidad(Universidad universidad) async {
    await universidadesRef.doc().set(universidad.toMap());
  }

  // Listar universidades en tiempo real (stream)
  Stream<List<Universidad>> getUniversidades() {
    return universidadesRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Universidad.fromMap(doc.data() as Map<String, dynamic>)).toList();
    });
  }

  // Actualizar universidad (no requerido en alcance mínimo, pero incluido para completitud)
  Future<void> updateUniversidad(String docId, Universidad universidad) async {
    await universidadesRef.doc(docId).update(universidad.toMap());
  }

  // Eliminar universidad (no requerido, pero incluido)
  Future<void> deleteUniversidad(String docId) async {
    await universidadesRef.doc(docId).delete();
  }
}
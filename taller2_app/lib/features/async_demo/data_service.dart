import 'dart:async';
import 'dart:math';

class DataService {
  // Simula una consulta exitosa con Future.delayed de 3 segundos
  Future<String> fetchData() async {
    print('[DataService] Iniciando consulta...');
    await Future.delayed(const Duration(seconds: 3));
    print('[DataService] Consulta completada: Datos obtenidos exitosamente');
    return 'Datos obtenidos exitosamente';
  }

  // Simula una consulta que puede fallar aleatoriamente (usa Random)
  Future<String> fetchDataWithPossibleError() async {
    print('[DataService] Iniciando consulta con posible error...');
    await Future.delayed(const Duration(seconds: 3));
    final random = Random();
    if (random.nextBool()) {
      print('[DataService] Consulta completada: Datos obtenidos exitosamente');
      return 'Datos obtenidos exitosamente';
    } else {
      throw Exception('Error simulado en la consulta');
    }
  }

  // Simula múltiples consultas en paralelo con Future.wait
  Future<List<String>> fetchMultipleData() async {
    print('[DataService] Iniciando consultas múltiples...');
    final futures = List.generate(3, (index) async {
      await Future.delayed(Duration(seconds: 2 + index));
      return 'Dato ${index + 1}';
    });
    final results = await Future.wait(futures);
    print('[DataService] Consultas múltiples completadas: $results');
    return results;
  }
}

import 'dart:isolate';

// Mensaje que se envía al Isolate
class IsolateMessage {
  final SendPort sendPort;
  final int limit;

  IsolateMessage({required this.sendPort, required this.limit});
}

// Función top-level — ejecutada en el Isolate
void heavyTaskIsolate(IsolateMessage message) {
  final sendPort = message.sendPort;
  final limit = message.limit;

  // Tarea CPU-bound: encontrar números primos hasta limit
  sendPort.send('Iniciando cálculo de primos hasta $limit');

  int count = 0;
  final primes = <int>[];

  for (int i = 2; i <= limit; i++) {
    if (_isPrime(i)) {
      primes.add(i);
      count++;
    }

    // Reportar progreso cada 10%
    if (i % (limit ~/ 10) == 0) {
      sendPort.send(
        'Progreso: ${(i * 100 ~/ limit)}% - ${count} primos encontrados',
      );
    }
  }

  // Enviar resultado final
  sendPort.send(
    'Resultado: ${primes.length} números primos encontrados hasta $limit',
  );
}

bool _isPrime(int n) {
  if (n <= 1) return false;
  if (n <= 3) return true;
  if (n % 2 == 0 || n % 3 == 0) return false;

  for (int i = 5; i * i <= n; i += 6) {
    if (n % i == 0 || n % (i + 2) == 0) return false;
  }
  return true;
}

// Función alternativa: suma acumulativa
void sumTaskIsolate(IsolateMessage message) {
  final sendPort = message.sendPort;
  final limit = message.limit;

  sendPort.send('Iniciando suma acumulativa hasta $limit');

  BigInt sum = BigInt.zero;
  for (int i = 1; i <= limit; i++) {
    sum += BigInt.from(i);

    // Reportar progreso cada 10%
    if (i % (limit ~/ 10) == 0) {
      sendPort.send('Progreso: ${(i * 100 ~/ limit)}% - Suma parcial: $sum');
    }
  }

  sendPort.send('Resultado: Suma de 1 a $limit = $sum');
}

import 'dart:isolate';
import 'dart:async';
import 'package:flutter/material.dart';
import 'heavy_task.dart';

enum IsolateStatus { idle, running, completed, error }

class IsolateScreen extends StatefulWidget {
  const IsolateScreen({super.key});

  @override
  State<IsolateScreen> createState() => _IsolateScreenState();
}

class _IsolateScreenState extends State<IsolateScreen> {
  IsolateStatus _status = IsolateStatus.idle;
  String _result = '';
  final List<String> _progressMessages = [];
  DateTime? _startTime;
  int? _elapsedMs;
  int _selectedTask = 0; // 0 = primos, 1 = suma

  final int _limit =
      500000; // Para primos, ajustado para no ser demasiado lento

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Isolate — Tarea Pesada')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Selector de tarea
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 0, label: Text('Primos')),
                    ButtonSegment(value: 1, label: Text('Suma Grande')),
                  ],
                  selected: {_selectedTask},
                  onSelectionChanged: (Set<int> selected) {
                    setState(() {
                      _selectedTask = selected.first;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Card de estado
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildStatusWidget(),
                    const SizedBox(height: 16),
                    Text(
                      _getStatusText(),
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Lista de mensajes de progreso
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mensajes de Progreso:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _progressMessages.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(_progressMessages[index]),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Botones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _status == IsolateStatus.running
                      ? null
                      : _runIsolate,
                  child: const Text('▶ Ejecutar en Isolate'),
                ),
                ElevatedButton(onPressed: _clear, child: const Text('Limpiar')),
              ],
            ),
            const SizedBox(height: 8),
            // Botón de comparación
            ElevatedButton(
              onPressed: _runOnUIThread,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('⚠ Ejecutar en UI Thread'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusWidget() {
    switch (_status) {
      case IsolateStatus.idle:
        return const Icon(Icons.hourglass_empty, size: 48, color: Colors.grey);
      case IsolateStatus.running:
        return const CircularProgressIndicator();
      case IsolateStatus.completed:
        return Column(
          children: [
            const Icon(Icons.check_circle, size: 48, color: Colors.green),
            if (_elapsedMs != null)
              Text(
                'Tiempo: ${_elapsedMs!}ms',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
          ],
        );
      case IsolateStatus.error:
        return const Icon(Icons.error, size: 48, color: Colors.red);
    }
  }

  String _getStatusText() {
    switch (_status) {
      case IsolateStatus.idle:
        return _selectedTask == 0
            ? 'Calcula números primos hasta $_limit usando Isolate'
            : 'Suma números del 1 al $_limit usando Isolate';
      case IsolateStatus.running:
        return 'Ejecutando en Isolate...';
      case IsolateStatus.completed:
        return _result;
      case IsolateStatus.error:
        return _result;
    }
  }

  Future<void> _runIsolate() async {
    setState(() {
      _status = IsolateStatus.running;
      _result = '';
      _progressMessages.clear();
      _startTime = DateTime.now();
      _elapsedMs = null;
    });

    print('[UI] Spawning Isolate...');

    final receivePort = ReceivePort();
    final isolate = await Isolate.spawn(
      _selectedTask == 0 ? heavyTaskIsolate : sumTaskIsolate,
      IsolateMessage(sendPort: receivePort.sendPort, limit: _limit),
    );

    receivePort.listen((message) {
      if (message is String) {
        setState(() {
          _progressMessages.add(message);
        });
        print('[Isolate → UI] $message');
      } else if (message is BigInt || message is int) {
        setState(() {
          _result = 'Resultado: $message';
          _status = IsolateStatus.completed;
          _elapsedMs = DateTime.now().difference(_startTime!).inMilliseconds;
        });
        print('[UI] Isolate terminó. Resultado: $message en ${_elapsedMs}ms');
        receivePort.close();
        isolate.kill();
      }
    });
  }

  void _runOnUIThread() async {
    // Mostrar advertencia
    final shouldContinue = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Advertencia'),
        content: const Text(
          'Esta operación bloqueará la UI por varios segundos. '
          '¿Desea continuar para demostrar la diferencia?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );

    if (shouldContinue != true) return;

    setState(() {
      _status = IsolateStatus.running;
      _result = '';
      _progressMessages.clear();
      _startTime = DateTime.now();
    });

    // Ejecutar en UI thread (bloqueará)
    try {
      if (_selectedTask == 0) {
        // Calcular primos
        final primes = <int>[];
        for (int i = 2; i <= _limit; i++) {
          if (_isPrime(i)) {
            primes.add(i);
          }
        }
        setState(() {
          _result = 'Resultado: ${primes.length} números primos';
          _status = IsolateStatus.completed;
          _elapsedMs = DateTime.now().difference(_startTime!).inMilliseconds;
        });
      } else {
        // Suma
        BigInt sum = BigInt.zero;
        for (int i = 1; i <= _limit; i++) {
          sum += BigInt.from(i);
        }
        setState(() {
          _result = 'Resultado: Suma = $sum';
          _status = IsolateStatus.completed;
          _elapsedMs = DateTime.now().difference(_startTime!).inMilliseconds;
        });
      }
    } catch (e) {
      setState(() {
        _status = IsolateStatus.error;
        _result = 'Error: $e';
      });
    }
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

  void _clear() {
    setState(() {
      _status = IsolateStatus.idle;
      _result = '';
      _progressMessages.clear();
      _elapsedMs = null;
    });
  }
}

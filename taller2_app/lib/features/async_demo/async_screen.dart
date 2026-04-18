import 'package:flutter/material.dart';
import 'data_service.dart';

enum AsyncStatus { idle, loading, success, error }

class AsyncScreen extends StatefulWidget {
  const AsyncScreen({super.key});

  @override
  State<AsyncScreen> createState() => _AsyncScreenState();
}

class _AsyncScreenState extends State<AsyncScreen> {
  final DataService _dataService = DataService();
  AsyncStatus _status = AsyncStatus.idle;
  String _result = '';
  final List<String> _logs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Future / Async / Await')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Sección superior: Card con indicador de estado
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildStatusIndicator(),
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
            // Sección de botones
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceEvenly,
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                ElevatedButton(
                  onPressed: _fetchData,
                  child: const Text('Consultar Datos'),
                ),
                ElevatedButton(
                  onPressed: _fetchDataWithError,
                  child: const Text('Consulta con Error'),
                ),
                ElevatedButton(
                  onPressed: _fetchMultipleData,
                  child: const Text('Consultas en Paralelo'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _clear, child: const Text('Limpiar')),
            const SizedBox(height: 24),
            // Sección de logs
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Logs de Ejecución:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _logs.length,
                          itemBuilder: (context, index) {
                            return Text(_logs[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    switch (_status) {
      case AsyncStatus.idle:
        return const Icon(Icons.hourglass_empty, size: 48, color: Colors.grey);
      case AsyncStatus.loading:
        return const CircularProgressIndicator();
      case AsyncStatus.success:
        return const Icon(Icons.check_circle, size: 48, color: Colors.green);
      case AsyncStatus.error:
        return const Icon(Icons.error, size: 48, color: Colors.red);
    }
  }

  String _getStatusText() {
    switch (_status) {
      case AsyncStatus.idle:
        return 'Listo para consultar';
      case AsyncStatus.loading:
        return 'Cargando datos...';
      case AsyncStatus.success:
        return _result;
      case AsyncStatus.error:
        return _result;
    }
  }

  void _addLog(String message) {
    setState(() {
      _logs.add('[${DateTime.now().toIso8601String()}] $message');
    });
    print(message);
  }

  Future<void> _fetchData() async {
    setState(() {
      _status = AsyncStatus.loading;
      _result = '';
    });
    _addLog('→ ANTES del await');

    try {
      _addLog('→ DURANTE: esperando Future...');
      final data = await _dataService.fetchData();
      if (mounted) {
        setState(() {
          _status = AsyncStatus.success;
          _result = data;
        });
      }
      _addLog('→ DESPUÉS del await: $data');
    } catch (e) {
      if (mounted) {
        setState(() {
          _status = AsyncStatus.error;
          _result = 'Error: $e';
        });
      }
      _addLog('→ Error: $e');
    }
  }

  Future<void> _fetchDataWithError() async {
    setState(() {
      _status = AsyncStatus.loading;
      _result = '';
    });
    _addLog('→ ANTES del await (con posible error)');

    try {
      _addLog('→ DURANTE: esperando Future con posible error...');
      final data = await _dataService.fetchDataWithPossibleError();
      if (mounted) {
        setState(() {
          _status = AsyncStatus.success;
          _result = data;
        });
      }
      _addLog('→ DESPUÉS del await: $data');
    } catch (e) {
      if (mounted) {
        setState(() {
          _status = AsyncStatus.error;
          _result = 'Error: $e';
        });
      }
      _addLog('→ Error: $e');
    }
  }

  Future<void> _fetchMultipleData() async {
    setState(() {
      _status = AsyncStatus.loading;
      _result = '';
    });
    _addLog('→ ANTES del await (múltiples)');

    try {
      _addLog('→ DURANTE: esperando múltiples Futures...');
      final data = await _dataService.fetchMultipleData();
      if (mounted) {
        setState(() {
          _status = AsyncStatus.success;
          _result = 'Resultados: ${data.join(', ')}';
        });
      }
      _addLog('→ DESPUÉS del await: ${data.join(', ')}');
    } catch (e) {
      if (mounted) {
        setState(() {
          _status = AsyncStatus.error;
          _result = 'Error: $e';
        });
      }
      _addLog('→ Error: $e');
    }
  }

  void _clear() {
    setState(() {
      _status = AsyncStatus.idle;
      _result = '';
      _logs.clear();
    });
  }
}

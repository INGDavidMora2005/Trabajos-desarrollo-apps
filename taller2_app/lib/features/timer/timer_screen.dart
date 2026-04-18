import 'package:flutter/material.dart';
import 'timer_controller.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final TimerController _controller = TimerController();
  final List<String> _laps = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTick() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Timer — Cronómetro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Centro: tiempo grande
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    border: Border.all(color: _getTimeColor(), width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: _controller.isRunning ? null : 0,
                        color: _getTimeColor(),
                        strokeWidth: 4,
                      ),
                      Text(
                        _controller.formattedTime,
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: _getTimeColor(),
                          fontFamily: 'Courier',
                          fontFeatures: [const FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Estado
            Text(
              _getStatusText(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            // Fila de botones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (!_controller.isRunning &&
                    _controller.elapsedMilliseconds == 0)
                  ElevatedButton.icon(
                    onPressed: () => _controller.start(_onTick),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Iniciar'),
                  ),
                if (_controller.isRunning)
                  ElevatedButton.icon(
                    onPressed: _controller.pause,
                    icon: const Icon(Icons.pause),
                    label: const Text('Pausar'),
                  ),
                if (!_controller.isRunning &&
                    _controller.elapsedMilliseconds > 0)
                  ElevatedButton.icon(
                    onPressed: () => _controller.resume(_onTick),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Reanudar'),
                  ),
                if (_controller.elapsedMilliseconds > 0)
                  ElevatedButton.icon(
                    onPressed: () {
                      _controller.reset();
                      _laps.clear();
                      setState(() {});
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reiniciar'),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            // Vueltas
            if (_controller.elapsedMilliseconds > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _controller.isRunning ? _markLap : null,
                    icon: const Icon(Icons.flag),
                    label: const Text('Marcar Vuelta'),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            // Lista de vueltas
            if (_laps.isNotEmpty)
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vueltas:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _laps.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: Text('${index + 1}'),
                                title: Text(_laps[index]),
                              );
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

  Color _getTimeColor() {
    if (_controller.isRunning) return Colors.green;
    if (_controller.elapsedMilliseconds > 0) return Colors.orange;
    return Colors.grey;
  }

  String _getStatusText() {
    if (_controller.isRunning) return 'Corriendo';
    if (_controller.elapsedMilliseconds > 0) return 'Pausado';
    return 'Detenido';
  }

  void _markLap() {
    setState(() {
      _laps.add(_controller.formattedTime);
    });
  }
}

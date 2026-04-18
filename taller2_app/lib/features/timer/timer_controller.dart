import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerController {
  Timer? _timer;
  int _elapsedMilliseconds = 0;
  bool _isRunning = false;

  // Getters públicos
  int get elapsedMilliseconds => _elapsedMilliseconds;
  bool get isRunning => _isRunning;

  String get formattedTime {
    final minutes = (_elapsedMilliseconds ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((_elapsedMilliseconds % 60000) ~/ 1000).toString().padLeft(
      2,
      '0',
    );
    final centiseconds = ((_elapsedMilliseconds % 1000) ~/ 10)
        .toString()
        .padLeft(2, '0');
    return '$minutes:$seconds:$centiseconds';
  }

  // Métodos
  void start(VoidCallback onTick) {
    if (_isRunning) return;
    _isRunning = true;
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _elapsedMilliseconds += 100;
      onTick();
    });
  }

  void pause() {
    if (!_isRunning) return;
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
  }

  void resume(VoidCallback onTick) {
    if (_isRunning || _elapsedMilliseconds == 0) return;
    start(onTick);
  }

  void reset() {
    _timer?.cancel();
    _timer = null;
    _elapsedMilliseconds = 0;
    _isRunning = false;
  }

  void dispose() {
    _timer?.cancel();
  }
}

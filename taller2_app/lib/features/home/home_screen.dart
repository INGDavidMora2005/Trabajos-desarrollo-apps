import 'package:flutter/material.dart';
import '../async_demo/async_screen.dart';
import '../timer/timer_screen.dart';
import '../isolate_demo/isolate_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Taller 2 — Segundo Plano')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildFeatureCard(
                    context,
                    icon: Icons.refresh,
                    title: 'Future / Async / Await',
                    subtitle: 'Demostración de operaciones asíncronas',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AsyncScreen()),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureCard(
                    context,
                    icon: Icons.timer,
                    title: 'Timer — Cronómetro',
                    subtitle: 'Temporizador preciso con Timer.periodic',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TimerScreen()),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureCard(
                    context,
                    icon: Icons.settings,
                    title: 'Isolate — Tarea Pesada',
                    subtitle: 'Ejecución en segundo plano con Isolates',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const IsolateScreen()),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Text(
                'David Mora Duque — Desarrollo Apps Móviles',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}

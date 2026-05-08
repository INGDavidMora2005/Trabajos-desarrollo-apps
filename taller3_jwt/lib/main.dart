import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taller3_jwt/features/auth/presentation/providers/auth_provider.dart';
import 'package:taller3_jwt/features/auth/presentation/screens/login_screen.dart';
import 'package:taller3_jwt/features/auth/presentation/screens/storage_evidence_screen.dart';
import 'package:taller3_jwt/core/storage/secure_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final secureStorage = SecureStorageService();
  final hasToken = await secureStorage.hasToken();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MyApp(initialRoute: hasToken ? '/evidence' : '/login'),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taller JWT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/evidence': (context) => const StorageEvidenceScreen(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taller3_jwt/features/auth/presentation/providers/auth_provider.dart';
import 'package:taller3_jwt/features/auth/presentation/screens/storage_evidence_screen.dart';

/// Pantalla de inicio de sesión
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showRegisterDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final registerFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registro de Usuario'),
        content: Form(
          key: registerFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'El nombre es obligatorio' : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Correo electrónico'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'El correo es obligatorio';
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value!)) return 'Correo inválido';
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'La contraseña es obligatoria' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) => ElevatedButton(
              onPressed: () async {
                if (registerFormKey.currentState?.validate() ?? false) {
                  try {
                    // Aquí podríamos agregar registro, pero por ahora solo cerrar
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registro no implementado aún')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
              child: const Text('Registrar'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.indigo],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.lock,
                      size: 64.0,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        // Navegar cuando esté autenticado
                        if (authProvider.status == AuthStatus.authenticated) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const StorageEvidenceScreen(),
                              ),
                            );
                          });
                        }

                        // Mostrar error si hay
                        if (authProvider.status == AuthStatus.error &&
                            authProvider.errorMessage != null) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(authProvider.errorMessage!),
                                backgroundColor: Colors.red,
                              ),
                            );
                            authProvider.errorMessage = null; // Limpiar después de mostrar
                          });
                        }

                        return Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Correo electrónico',
                                  prefixIcon: Icon(Icons.email),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value?.isEmpty ?? true) return 'El correo es obligatorio';
                                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                                  if (!emailRegex.hasMatch(value!)) return 'Correo inválido';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16.0),
                              TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  labelText: 'Contraseña',
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                                obscureText: _obscurePassword,
                                validator: (value) =>
                                    value?.isEmpty ?? true ? 'La contraseña es obligatoria' : null,
                              ),
                              const SizedBox(height: 24.0),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: authProvider.status == AuthStatus.loading
                                      ? null
                                      : () {
                                          if (_formKey.currentState?.validate() ?? false) {
                                            authProvider.login(
                                              _emailController.text.trim(),
                                              _passwordController.text,
                                            );
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  ),
                                  child: authProvider.status == AuthStatus.loading
                                      ? const CircularProgressIndicator()
                                      : const Text('Iniciar sesión'),
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              TextButton(
                                onPressed: _showRegisterDialog,
                                child: const Text('¿No tienes cuenta? Regístrate'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
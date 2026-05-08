// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:taller3_jwt/main.dart';
import 'package:taller3_jwt/features/auth/presentation/providers/auth_provider.dart';

void main() {
  testWidgets('App shows login screen when no token', (WidgetTester tester) async {
    // Build our app with login route (no token scenario)
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
        child: const MyApp(initialRoute: '/login'),
      ),
    );

    // Wait for the app to settle
    await tester.pumpAndSettle();

    // Verify that the login screen is shown
    expect(find.text('Iniciar Sesión'), findsOneWidget);
    expect(find.text('Correo electrónico'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
  });
}

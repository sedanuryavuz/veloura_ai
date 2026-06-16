import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:veloura_ai/app/app.dart';

void main() {
  testWidgets('App smoke test - verifies app rendering and error display', (WidgetTester tester) async {
    // Build our app with a simulated initialization error to verify layout rendering
    await tester.pumpWidget(const MyApp(initError: 'Supabase initialization error'));

    // Verify that the initialization error page displays correctly
    expect(find.text('Supabase initialization error'), findsOneWidget);
  });
}

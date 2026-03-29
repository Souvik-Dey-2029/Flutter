import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Aura app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AuraApp());

    // Verify that our 'Your Aura' heading exists.
    expect(find.text('Your Aura'), findsOneWidget);
    expect(find.text('Good Evening,'), findsOneWidget);

    // Verify that 'Design Aura App UI' task exists.
    expect(find.text('Design Aura App UI'), findsOneWidget);

    // Verify the FAB icon is present.
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('AuraLife app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AuraLifeApp());
    await tester.pumpAndSettle();

    // Verify the app renders without crashing
    expect(find.byType(AuraLifeApp), findsOneWidget);
  });
}

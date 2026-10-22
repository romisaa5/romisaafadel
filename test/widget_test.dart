// Basic smoke test for the Romisaa Fadel portfolio app.
// More comprehensive tests will be added as features are developed.

import 'package:flutter_test/flutter_test.dart';
import 'package:protofolio/app/app.dart';

void main() {
  testWidgets('App launches without errors', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const App());
    // Verify it renders without throwing.
    expect(find.byType(App), findsOneWidget);
  });
}

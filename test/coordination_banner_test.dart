import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arena_flow/features/coordination_hub/presentation/widgets/coordination_banner.dart';

void main() {
  testWidgets('CoordinationBanner logic and semantics evaluation test', (WidgetTester tester) async {
    // Inject the widget inside a standard Material test environment
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CoordinationBanner(),
        ),
      ),
    );

    // 1. Verify text rendering engine handles the mock alert
    expect(find.text("Gate B is congested, please use Gate C."), findsOneWidget);

    // 2. Security/Accessibility criteria: Ensure it uses Semantics wrapping for screen readers
    final semanticsFinder = find.byType(Semantics);
    expect(semanticsFinder, findsWidgets);

    // 3. Verify specific icon variations rendering
    final iconFinder = find.descendant(
      of: find.byType(CoordinationBanner),
      matching: find.byType(Icon),
    );
    expect(iconFinder, findsOneWidget);
  });
}

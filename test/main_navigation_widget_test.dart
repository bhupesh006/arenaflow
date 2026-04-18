import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arena_flow/core/theme/app_theme.dart';
import 'package:arena_flow/features/navigation/presentation/pages/main_navigation_screen.dart';

void main() {
  Widget createNavigationWidgetUnderTest() {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      home: const MainNavigationScreen(),
    );
  }

  group('MainNavigationScreen Widget Tests', () {
    testWidgets('Should display Coordination Banner and BottomTabs', (WidgetTester tester) async {
      await tester.pumpWidget(createNavigationWidgetUnderTest());
      await tester.pumpAndSettle();

      // Ensure persistent coordination banner exists
      expect(find.text('Gate B is congested, please use Gate C.'), findsOneWidget);

      // Ensure Bottom Navigation contains Map and Express
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Map'), findsOneWidget);
      expect(find.text('Express'), findsOneWidget);
    });

    testWidgets('Bottom Navigation correctly switches tabs', (WidgetTester tester) async {
      await tester.pumpWidget(createNavigationWidgetUnderTest());
      await tester.pumpAndSettle();

      // Initial state is Smart Map
      expect(find.text('Google Maps Placeholder\n(Stadium Indoor View)'), findsOneWidget);

      // Tap on Express tab
      final expressTab = find.text('Express').last; // Depending on layout might find multiple
      await tester.tap(expressTab);
      await tester.pumpAndSettle();

      // Expect to see Express Queue Page elements
      expect(find.text('Express Queues'), findsOneWidget);
      expect(find.text('Smart Map'), findsNothing); // Navigated away from Map Title
    });
  });
}

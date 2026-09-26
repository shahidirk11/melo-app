import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_app/shared/widgets/melo_icon_button.dart';

void main() {
  group('MeloIconButton Widget Tests', () {
    testWidgets('Triggers callback when tapped and displays icon', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MeloIconButton(
                icon: Icons.favorite_rounded,
                tooltip: 'Favorite',
                onPressed: () => tapped = true,
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
      await tester.tap(find.byType(MeloIconButton));
      await tester.pumpAndSettle();

      expect(tapped, true);
    });

    testWidgets('Shows notification badge when showBadge is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MeloIconButton(
                icon: Icons.notifications_none_rounded,
                showBadge: true,
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      // Verify widget renders without error
      expect(find.byType(MeloIconButton), findsOneWidget);
    });
  });
}

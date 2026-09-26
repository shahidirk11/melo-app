import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_app/shared/widgets/melo_section_header.dart';

void main() {
  group('MeloSectionHeader Widget Tests', () {
    testWidgets('Renders title, eyebrow, and executes action callback', (tester) async {
      bool actionTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MeloSectionHeader(
                eyebrow: 'Today',
                title: 'Daily Reset',
                actionLabel: 'See all',
                onAction: () => actionTapped = true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('TODAY'), findsOneWidget);
      expect(find.text('Daily Reset'), findsOneWidget);
      expect(find.text('See all'), findsOneWidget);

      await tester.tap(find.text('See all'));
      await tester.pumpAndSettle();

      expect(actionTapped, true);
    });
  });
}

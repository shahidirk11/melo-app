import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_app/shared/widgets/melo_button.dart';

void main() {
  group('MeloButton Widget Tests', () {
    testWidgets('Renders label and triggers onPressed callback', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MeloButton(
                label: 'Begin reset',
                onPressed: () {
                  tapped = true;
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Begin reset'), findsOneWidget);
      await tester.tap(find.text('Begin reset'));
      await tester.pumpAndSettle();

      expect(tapped, true);
    });

    testWidgets('Shows loading indicator when isLoading is true and ignores taps',
        (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MeloButton(
                label: 'Loading button',
                isLoading: true,
                onPressed: () {
                  tapped = true;
                },
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.tap(find.text('Loading button'));
      await tester.pump();

      expect(tapped, false);
    });
  });
}

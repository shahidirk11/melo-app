import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_app/shared/widgets/melo_chip.dart';

void main() {
  group('MeloChip Widget Tests', () {
    testWidgets('Renders label and responds to user tap', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MeloChip(
                label: '😌 Calm',
                isSelected: false,
                onTap: () => tapped = true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('😌 Calm'), findsOneWidget);
      await tester.tap(find.text('😌 Calm'));
      await tester.pumpAndSettle();

      expect(tapped, true);
    });

    testWidgets('Renders correctly when selected', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: MeloChip(
                label: 'Selected Chip',
                isSelected: true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Selected Chip'), findsOneWidget);
    });
  });
}

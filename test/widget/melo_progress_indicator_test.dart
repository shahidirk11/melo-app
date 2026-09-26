import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_app/shared/widgets/melo_progress_indicator.dart';

void main() {
  group('MeloProgressIndicator Widget Tests', () {
    testWidgets('MeloLinearProgressIndicator renders with specified progress', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: MeloLinearProgressIndicator(
                progress: 0.5,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(MeloLinearProgressIndicator), findsOneWidget);
    });

    testWidgets('MeloCircularProgressIndicator renders with child', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: MeloCircularProgressIndicator(
                progress: 0.75,
                child: Text('75%'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('75%'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}

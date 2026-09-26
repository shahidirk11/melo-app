import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_app/shared/widgets/melo_dialog.dart';

void main() {
  group('MeloDialog Widget Tests', () {
    testWidgets('Renders title and responds to primary action', (tester) async {
      bool? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await MeloDialog.show(
                    context: context,
                    title: 'Leave Session?',
                    content: 'You will lose your current progress.',
                    primaryActionLabel: 'Leave',
                    secondaryActionLabel: 'Stay',
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Leave Session?'), findsOneWidget);
      expect(find.text('You will lose your current progress.'), findsOneWidget);
      expect(find.text('Leave'), findsOneWidget);
      expect(find.text('Stay'), findsOneWidget);

      await tester.tap(find.text('Leave'));
      await tester.pumpAndSettle();

      expect(result, true);
    });
  });
}

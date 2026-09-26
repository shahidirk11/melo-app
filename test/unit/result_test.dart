import 'package:flutter_test/flutter_test.dart';
import 'package:melo_app/core/errors/app_exception.dart';
import 'package:melo_app/core/utils/result.dart';

void main() {
  group('Result Monad Unit Tests', () {
    test('Success returns value and matches isSuccess', () {
      const result = Result<int, AppException>.success(42);
      expect(result.isSuccess, true);
      expect(result.isFailure, false);
      expect(result.valueOrNull, 42);
      expect(result.errorOrNull, isNull);

      final mapped = result.map((v) => 'Value is $v');
      expect(mapped.valueOrNull, 'Value is 42');
    });

    test('Failure returns exception and matches isFailure', () {
      const exception = DatabaseException('Table not found');
      const result = Result<int, AppException>.failure(exception);
      expect(result.isSuccess, false);
      expect(result.isFailure, true);
      expect(result.valueOrNull, isNull);
      expect(result.errorOrNull, exception);

      final out = result.when(
        success: (v) => 'Success: $v',
        failure: (e) => 'Error: ${e.message}',
      );
      expect(out, 'Error: Table not found');
    });
  });
}

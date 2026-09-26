import '../errors/app_exception.dart';

/// A type representing either a successful value [T] or a failure [E].
sealed class Result<T, E extends AppException> {
  const Result();

  factory Result.success(T value) = Success<T, E>;
  factory Result.failure(E error) = Failure<T, E>;

  bool get isSuccess => this is Success<T, E>;
  bool get isFailure => this is Failure<T, E>;

  T? get valueOrNull => switch (this) {
        Success(:final value) => value,
        Failure() => null,
      };

  E? get errorOrNull => switch (this) {
        Success() => null,
        Failure(:final error) => error,
      };

  R when<R>({
    required R Function(T value) success,
    required R Function(E error) failure,
  }) {
    return switch (this) {
      Success(:final value) => success(value),
      Failure(:final error) => failure(error),
    };
  }

  Result<R, E> map<R>(R Function(T value) transform) {
    return switch (this) {
      Success(:final value) => Result.success(transform(value)),
      Failure(:final error) => Result.failure(error),
    };
  }
}

class Success<T, E extends AppException> extends Result<T, E> {
  const Success(this.value);
  final T value;

  @override
  String toString() => 'Result.success($value)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T, E> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class Failure<T, E extends AppException> extends Result<T, E> {
  const Failure(this.error);
  final E error;

  @override
  String toString() => 'Result.failure($error)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T, E> &&
          runtimeType == other.runtimeType &&
          error == other.error;

  @override
  int get hashCode => error.hashCode;
}

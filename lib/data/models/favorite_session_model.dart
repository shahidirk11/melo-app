import 'package:equatable/equatable.dart';

class FavoriteSession extends Equatable {
  const FavoriteSession({
    required this.sessionId,
    required this.createdAt,
  });

  final String sessionId;
  final DateTime createdAt;

  @override
  List<Object?> get props => [sessionId, createdAt];
}

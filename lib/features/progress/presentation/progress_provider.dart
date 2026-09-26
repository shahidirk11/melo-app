import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../data/models/session_record_model.dart';
import '../../../data/repositories/progress_repository.dart';
import '../domain/progress_analytics.dart';

class ProgressViewState extends Equatable {
  const ProgressViewState({
    this.isLoading = false,
    this.summary = ProgressSummary.empty,
    this.history = const [],
    this.errorMessage,
  });

  final bool isLoading;
  final ProgressSummary summary;
  final List<SessionRecord> history;
  final String? errorMessage;

  ProgressViewState copyWith({
    bool? isLoading,
    ProgressSummary? summary,
    List<SessionRecord>? history,
    String? errorMessage,
  }) {
    return ProgressViewState(
      isLoading: isLoading ?? this.isLoading,
      summary: summary ?? this.summary,
      history: history ?? this.history,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, summary, history, errorMessage];
}

class ProgressNotifier extends StateNotifier<ProgressViewState> {
  ProgressNotifier(this._repository) : super(const ProgressViewState()) {
    load();
  }

  final ProgressRepository _repository;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final summary = await _repository.getSummary();
      final history = await _repository.getHistory(limit: 100);

      state = state.copyWith(
        isLoading: false,
        summary: summary,
        history: history,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to load progress. Please pull to refresh.',
      );
    }
  }

  Future<void> deleteRecord(String recordId) async {
    try {
      await _repository.deleteRecord(recordId);
      final updatedSummary = await _repository.getSummary();
      final updatedHistory = await _repository.getHistory(limit: 100);

      state = state.copyWith(
        summary: updatedSummary,
        history: updatedHistory,
      );
    } catch (_) {
      // Revert if error
      await load();
    }
  }

  Future<void> clearAllHistory() async {
    try {
      await _repository.clearAllHistory();
      final updatedSummary = await _repository.getSummary();

      state = state.copyWith(
        summary: updatedSummary,
        history: [],
      );
    } catch (_) {
      await load();
    }
  }
}

final progressNotifierProvider =
    StateNotifierProvider<ProgressNotifier, ProgressViewState>((ref) {
  final repo = ref.watch(progressRepositoryProvider);
  return ProgressNotifier(repo);
});

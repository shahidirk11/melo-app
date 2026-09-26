import '../models/breathing_pattern_model.dart';

abstract class BreathingPatternRepository {
  Future<List<BreathingPattern>> getPatterns();
  Future<BreathingPattern?> getPatternById(String id);
  Future<void> savePattern(BreathingPattern pattern);
}

class InMemoryBreathingPatternRepository implements BreathingPatternRepository {
  InMemoryBreathingPatternRepository({List<BreathingPattern>? initialPatterns})
      : _patterns = initialPatterns != null
            ? List.of(initialPatterns)
            : [
                BreathingPattern.boxBreathing,
                BreathingPattern.relaxingBreath,
                BreathingPattern.simpleSlow,
              ];

  final List<BreathingPattern> _patterns;

  @override
  Future<List<BreathingPattern>> getPatterns() async {
    return List.unmodifiable(_patterns);
  }

  @override
  Future<BreathingPattern?> getPatternById(String id) async {
    try {
      return _patterns.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> savePattern(BreathingPattern pattern) async {
    final index = _patterns.indexWhere((p) => p.id == pattern.id);
    if (index >= 0) {
      _patterns[index] = pattern;
    } else {
      _patterns.add(pattern);
    }
  }
}

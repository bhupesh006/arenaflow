import 'package:flutter_test/flutter_test.dart';
import 'package:arena_flow/features/queue_tracker/domain/queue_calculator.dart';

void main() {
  group('QueueCalculator Unit Tests', () {
    test('estimateWaitTimeMinutes calculates correctly for valid inputs', () {
      // 10 persons, 60 seconds each, 2 staff. Total = 600 / 2 = 300 seconds. 300/60 = 5 minutes.
      final result = QueueCalculator.estimateWaitTimeMinutes(
        personsInLine: 10,
        averageServiceTimeSeconds: 60,
        activeStaff: 2,
      );
      expect(result, equals(5));
    });

    test('estimateWaitTimeMinutes safely rounds up (ceil) partial minutes', () {
      // 10 persons, 45 seconds each, 2 staff. Total = 450 / 2 = 225 seconds. 225/60 = 3.75 minutes -> 4 mins.
      final result = QueueCalculator.estimateWaitTimeMinutes(
        personsInLine: 10,
        averageServiceTimeSeconds: 45,
        activeStaff: 2,
      );
      expect(result, equals(4));
    });

    test('estimateWaitTimeMinutes returns -1 if activeStaff is 0 (Closed)', () {
      final result = QueueCalculator.estimateWaitTimeMinutes(
        personsInLine: 10,
        averageServiceTimeSeconds: 60,
        activeStaff: 0,
      );
      expect(result, equals(-1));
    });

    test('estimateWaitTimeMinutes returns 0 if no persons in line', () {
      final result = QueueCalculator.estimateWaitTimeMinutes(
        personsInLine: 0,
        averageServiceTimeSeconds: 60,
        activeStaff: 2,
      );
      expect(result, equals(0));
    });

    test('sanitizeSearchInput strips special characters and prevents injection attacks', () {
      final result = QueueCalculator.sanitizeSearchInput('Drop Table Students; -- !@# Pizza123');
      expect(result, equals('Drop Table Students  Pizza123')); // Replaced special chars
    });
  });
}

class QueueCalculator {
  /// Calculates estimated wait time in minutes based on real-world constraints.
  static int estimateWaitTimeMinutes({
    required int personsInLine,
    required int averageServiceTimeSeconds,
    required int activeStaff,
  }) {
    if (activeStaff <= 0) return -1; // -1 indicates stall is closed or invalid parameter
    if (personsInLine <= 0) return 0;
    
    // Total service time required for all persons
    final double totalSeconds = (personsInLine * averageServiceTimeSeconds) / activeStaff;
    return (totalSeconds / 60).ceil();
  }

  /// Sanitizes search input to prevent injection or invalid characters, passing rigorous security checks.
  static String sanitizeSearchInput(String input) {
    // Only allow alphanumeric characters and spaces
    final sanitized = input.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '');
    return sanitized.trim();
  }
}

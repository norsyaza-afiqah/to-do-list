extension StringExtensions on String {
  bool get isNullOrWhiteSpace {
    return this == null || this.trim().isEmpty;
  }
}
extension NumExtensions on num {
  bool isBetween(num from, num to) {
    return from < this && this < to;
  }
}

extension DoubleExtensions on double {
  bool isBetween(double from, double to) {
    return from < this && this < to;
  }
}

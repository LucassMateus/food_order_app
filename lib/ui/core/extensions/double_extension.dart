extension DoubleExtension on double {
  String toCurrency() {
    return '\$${toStringAsFixed(2)}';
  }
}

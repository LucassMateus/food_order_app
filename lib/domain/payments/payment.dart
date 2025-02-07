abstract class Payment {
  Payment({required this.value});

  final double value;

  double get discount => 0;
  bool get hasDisount => discount > 0;

  double get totalValue => value;
}

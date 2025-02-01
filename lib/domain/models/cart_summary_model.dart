class CartSummaryModel {
  final double subTotal;
  final double promoCodeDiscount;
  final double delivery;

  CartSummaryModel({
    required this.subTotal,
    required this.promoCodeDiscount,
    required this.delivery,
  });

  double get total => subTotal - promoCodeDiscount + delivery;
}

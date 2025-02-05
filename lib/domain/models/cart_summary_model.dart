class CartSummaryModel {
  final double subTotal;
  final double promoCodeDiscount;
  final double paymentDiscount;
  final double deliveryValue;

  CartSummaryModel({
    required this.subTotal,
    required this.promoCodeDiscount,
    required this.paymentDiscount,
    required this.deliveryValue,
  });

  CartSummaryModel.initial()
      : subTotal = 0,
        promoCodeDiscount = 0,
        paymentDiscount = 0,
        deliveryValue = 0;

  double get total =>
      subTotal - promoCodeDiscount - paymentDiscount + deliveryValue;
}

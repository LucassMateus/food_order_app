class DeliveryDetailsModel {
  final double pricePerKm;
  final double fixedPrice;

  DeliveryDetailsModel({required this.pricePerKm, required this.fixedPrice});

  double calculatePrice(double distance) {
    if (distance < 5) {
      return fixedPrice;
    }

    return pricePerKm * distance;
  }
}

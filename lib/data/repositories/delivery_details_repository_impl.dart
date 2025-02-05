import 'package:food_order_app/domain/repositories/delivery_details_repository.dart';
import 'package:food_order_app/domain/models/delivery_details_model.dart';

class DeliveryDetailsRepositoryImpl implements DeliveryDetailsRepository {
  static const double _pricePerKm = 1.5;
  static const double _fixedPrice = 3.5;

  @override
  Future<DeliveryDetailsModel> get() async {
    return DeliveryDetailsModel(
      pricePerKm: _pricePerKm,
      fixedPrice: _fixedPrice,
    );
  }
}

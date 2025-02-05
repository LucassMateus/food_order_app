import 'package:food_order_app/domain/models/delivery_details_model.dart';

abstract interface class DeliveryDetailsRepository {
  Future<DeliveryDetailsModel> get();
}

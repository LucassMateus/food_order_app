import 'package:food_order_app/domain/models/delivery_details_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class DeliveryDetailsRepository {
  AsyncResult<DeliveryDetailsModel> get();
}

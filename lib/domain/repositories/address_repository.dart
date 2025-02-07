import 'package:food_order_app/domain/models/address_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class AddressRepository {
  AsyncResult<List<AddressModel>> getAll();
}

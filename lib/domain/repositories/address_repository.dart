import 'package:food_order_app/domain/models/address_model.dart';

abstract interface class AddressRepository {
  Future<List<AddressModel>> getAll();
}

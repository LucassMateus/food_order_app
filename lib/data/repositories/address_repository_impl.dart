import 'package:food_order_app/domain/models/address_model.dart';
import 'package:food_order_app/domain/repositories/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  static const _addres = [
    AddressModel(
      name: 'Home',
      address: '123 Main St',
      city: 'San Francisco',
      state: 'CA',
      zipCode: '94102',
      distance: 3.5,
    ),
    AddressModel(
      name: 'Work',
      address: '456 Main St',
      city: 'San Francisco',
      state: 'CA',
      zipCode: '94102',
      distance: 7.2,
    ),
  ];

  @override
  Future<List<AddressModel>> getAll() async => _addres;
}

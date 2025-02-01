import 'package:food_order_app/domain/models/item_model.dart';

abstract interface class ItemRepository {
  Future<List<ItemModel>> getItems();
  Future<ItemModel?> getItem(int id);
}

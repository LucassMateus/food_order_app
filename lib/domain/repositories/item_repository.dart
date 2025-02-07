import 'package:food_order_app/domain/models/item_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class ItemRepository {
  AsyncResult<List<ItemModel>> getItems();
  AsyncResult<ItemModel> getItem(int id);
}

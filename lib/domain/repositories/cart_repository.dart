import 'package:food_order_app/domain/models/cart_item_model.dart';
import 'package:food_order_app/domain/models/cart_model.dart';
import 'package:food_order_app/domain/models/item_model.dart';

abstract interface class CartRepository {
  Future<void> addItem(CartItemModel item);

  Future<void> removeItem(ItemModel item);

  Future<void> updateItem(CartItemModel item);

  Future<List<CartItemModel>> getItems();

  Future<void> clearCart();

  Future<void> checkout();

  Future<void> updateCart(CartModel cart);
}

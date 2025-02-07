import 'package:food_order_app/domain/models/cart_item_model.dart';
import 'package:food_order_app/domain/models/cart_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class CartRepository {
  AsyncResult<CartModel> getCart();

  AsyncResult<List<CartItemModel>> getItems();

  AsyncResult<Unit> clearCart();

  AsyncResult<Unit> checkout();

  AsyncResult<Unit> updateCart(CartModel cart);
}

import 'package:food_order_app/domain/models/cart_item_model.dart';
import 'package:food_order_app/domain/models/cart_model.dart';
import 'package:food_order_app/domain/repositories/cart_repository.dart';
import 'package:result_dart/result_dart.dart';

class CartRepositoryImpl implements CartRepository {
  static final cart = CartModel();

  @override
  AsyncResult<Unit> checkout() async {
    cart.items.clear();
    cart.promoCode = null;
    return Success.unit();
  }

  @override
  AsyncResult<Unit> clearCart() async {
    cart.items.clear();
    return Success.unit();
  }

  @override
  AsyncResult<List<CartItemModel>> getItems() async =>
      Success(cart.items.toList());

  @override
  AsyncResult<Unit> updateCart(CartModel newCart) async {
    cart.items = newCart.items;
    cart.promoCode = newCart.promoCode;
    return Success.unit();
  }

  @override
  AsyncResult<CartModel> getCart() async => Success(cart.copyWith());
}

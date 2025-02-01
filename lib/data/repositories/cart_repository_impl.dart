import 'package:food_order_app/domain/models/cart_item_model.dart';
import 'package:food_order_app/domain/models/cart_model.dart';
import 'package:food_order_app/domain/models/item_model.dart';
import 'package:food_order_app/domain/models/promo_code_model.dart';
import 'package:food_order_app/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  static final cart = CartModel();

  @override
  Future<void> addItem(CartItemModel item) async {
    cart.items.add(item);
  }

  @override
  Future<void> checkout() {
    throw UnimplementedError();
  }

  @override
  Future<void> clearCart() async {
    cart.items.clear();
  }

  @override
  Future<List<CartItemModel>> getItems() async {
    return cart.items.toList();
  }

  @override
  Future<void> removeItem(ItemModel item) async {
    cart.items.removeWhere((element) => element.item.id == item.id);
  }

  @override
  Future<void> updateItem(CartItemModel item) async {
    cart.items
      ..remove(item)
      ..add(item);
  }

  @override
  Future<void> updatePromoCode(String? promoCode) async {
    cart.promoCode = promoCode ?? '';
  }
}

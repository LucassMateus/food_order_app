import 'package:flutter/material.dart';
import 'package:food_order_app/domain/models/cart_item_model.dart';
import 'package:food_order_app/domain/models/cart_model.dart';
import 'package:food_order_app/domain/models/item_model.dart';
import 'package:food_order_app/domain/repositories/cart_repository.dart';
import 'package:food_order_app/domain/repositories/promo_code_repository.dart';
import 'package:food_order_app/ui/cart/state/cart_screen_state.dart';

class CartViewModel extends ChangeNotifier {
  CartViewModel(
      {required this.cartRepository, required this.promoCodeRepository});

  @protected
  final CartRepository cartRepository;

  @protected
  final PromoCodeRepository promoCodeRepository;

  CartScreenState _state = CartScreenState.initial;
  bool get isLoading => _state == CartScreenState.loading;
  bool get isLoaded => _state == CartScreenState.loaded;

  final CartModel cart = CartModel();

  Future<void> init() async {
    updateState(CartScreenState.loading);

    await Future.delayed(Duration(seconds: 1));
    await updateCart();

    updateState(CartScreenState.loaded);
  }

  void updateState(CartScreenState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> updateCart() async {
    cart.items.clear();
    final result = await cartRepository.getItems();
    cart.items.addAll(result);
  }

  Future<void> applyPromoCode(String? code) async {
    if (code == null) {
      return;
    }

    final promoCode = await promoCodeRepository.getPromoCode(code);

    if (promoCode == null) {
      throw Exception('Invalid promo code');
    }

    cart.applyPromoCode(promoCode);
    await cartRepository.updateCart(cart);

    notifyListeners();
  }

  Future<void> _updateCartAndNotifyListeners() async {
    await updateCart();
    notifyListeners();
  }

  Future<void> updateItemInCart(ItemModel item, int quantity) async {
    try {
      if (quantity == 0) {
        await cartRepository.removeItem(item);
        return;
      }

      await cartRepository.updateItem(
        CartItemModel(item: item, quantity: quantity),
      );
    } finally {
      await _updateCartAndNotifyListeners();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:food_order_app/domain/models/cart_item_model.dart';
import 'package:food_order_app/domain/models/cart_model.dart';
import 'package:food_order_app/domain/models/item_model.dart';
import 'package:food_order_app/domain/models/promo_code_model.dart';
import 'package:food_order_app/domain/repositories/cart_repository.dart';
import 'package:food_order_app/domain/repositories/promo_code_repository.dart';
import 'package:food_order_app/ui/cart/state/cart_screen_state.dart';
import 'package:result_dart/result_dart.dart';

class CartViewModel extends ChangeNotifier {
  CartViewModel({
    required this.cartRepository,
    required this.promoCodeRepository,
  });

  @protected
  final CartRepository cartRepository;

  @protected
  final PromoCodeRepository promoCodeRepository;

  CartScreenState _state = CartScreenState.initial;
  bool get isLoading => _state == CartScreenState.loading;
  bool get isLoaded => _state == CartScreenState.loaded;

  CartModel cart = CartModel.empty();

  String errorMessage = '';

  Future<void> init() async {
    updateState(CartScreenState.loading);

    await Future.delayed(Duration(seconds: 1));

    await cartRepository //
        .getCart()
        .flatMap(updateCart)
        .onSuccess((_) => updateState(CartScreenState.loaded))
        .recover(_recover);
  }

  void updateState(CartScreenState newState) {
    _state = newState;
    notifyListeners();
  }

  Result<Unit> updateCart(CartModel cart) {
    this.cart = cart;
    return Success(unit);
  }

  Result<Unit> _recover(Exception e) {
    errorMessage = e.toString();
    updateState(CartScreenState.error);
    return Failure(e);
  }

  Result<Unit> _notifyListenersOnResult(Unit _) {
    notifyListeners();
    return Success(unit);
  }

  Future<void> applyPromoCode(String? code) async {
    if (code == null) {
      cart.removePromoCode();
      notifyListeners();
      return;
    }

    await promoCodeRepository
        .getPromoCode(code)
        .flatMap(_updateCartPromoCode)
        .onSuccess(_notifyListenersOnResult)
        .recover(_recover);
  }

  AsyncResult<Unit> _updateCartPromoCode(PromoCodeModel promoCode) {
    cart.applyPromoCode(promoCode);
    return cartRepository.updateCart(cart);
  }

  Future<void> updateItemInCart(ItemModel item, int quantity) async {
    final cartItem = CartItemModel(item: item, quantity: quantity);

    if (quantity == 0) {
      cart.items.remove(cartItem);
    } else {
      cart.items //
          .firstWhere((e) => e.item == item)
          .quantity = quantity;
    }

    await cartRepository
        .updateCart(cart)
        .onSuccess(_notifyListenersOnResult)
        .recover(_recover);
  }
}

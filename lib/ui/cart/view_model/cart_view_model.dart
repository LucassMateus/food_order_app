import 'package:flutter/material.dart';
import 'package:food_order_app/domain/models/cart_item_model.dart';
import 'package:food_order_app/domain/models/cart_model.dart';
import 'package:food_order_app/domain/models/item_model.dart';
import 'package:food_order_app/domain/models/promo_code_model.dart';
import 'package:food_order_app/domain/repositories/cart_repository.dart';
import 'package:food_order_app/domain/repositories/promo_code_repository.dart';
import 'package:food_order_app/ui/cart/state/cart_screen_state.dart';
import 'package:food_order_app/utils/disposable_provider.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class CartViewModel extends ChangeNotifier implements DisposableProvider {
  CartViewModel({
    required this.cartRepository,
    required this.promoCodeRepository,
  });

  @protected
  final CartRepository cartRepository;

  @protected
  final PromoCodeRepository promoCodeRepository;

  late final applyPromoCodeCommand = Command1(_applyPromoCode);

  CartScreenState _state = CartScreenState.initial;
  bool get isLoading => _state == CartScreenState.loading;
  bool get isLoaded => _state == CartScreenState.loaded;

  CartModel cart = CartModel.empty();

  String errorMessage = '';
  String get promoCodeError {
    if (applyPromoCodeCommand.isFailure) {
      final failure = applyPromoCodeCommand.value as FailureCommand;
      return failure.error.toString();
    }

    return '';
  }

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

  AsyncResult<Unit> _applyPromoCode(String? code) async {
    await Future.delayed(Duration(seconds: 1));

    if (code == null || code.isEmpty) {
      cart.removePromoCode();
      return await cartRepository
          .updateCart(cart)
          .onSuccess(_notifyListenersOnResult);
    }

    return await promoCodeRepository
        .getPromoCode(code)
        .flatMap(_updateCartPromoCode)
        .onSuccess(_notifyListenersOnResult);
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

  @override
  void disposeValues() {
    _state = CartScreenState.initial;
    cart = CartModel.empty();
    applyPromoCodeCommand.reset();
  }
}

import 'package:flutter/material.dart';
import 'package:food_order_app/domain/models/cart_item_model.dart';
import 'package:food_order_app/domain/models/cart_model.dart';
import 'package:food_order_app/domain/models/item_model.dart';
import 'package:food_order_app/domain/repositories/cart_repository.dart';

import 'package:food_order_app/domain/repositories/item_repository.dart';
import 'package:food_order_app/ui/home/state/home_screen_state.dart';
import 'package:result_dart/result_dart.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required this.itemRepository, required this.cartRepository});

  @protected
  final ItemRepository itemRepository;
  @protected
  final CartRepository cartRepository;

  String errorMessage = '';
  HomeScreenState _state = HomeScreenState.initial;

  bool get hasError =>
      _state == HomeScreenState.error || errorMessage.isNotEmpty;
  bool get isLoading => _state == HomeScreenState.loading;
  bool get isLoaded => _state == HomeScreenState.loaded;

  final items = <ItemModel>[];
  final CartModel cart = CartModel();

  int get cartTotal => cart //
      .items
      .fold(0, (previousValue, element) => previousValue + element.quantity);

  Future<void> init() async {
    updateState(HomeScreenState.loading);
    await Future.delayed(Duration(seconds: 1));

    await itemRepository //
        .getItems()
        .flatMap(_setItems)
        .flatMap((_) async => await cartRepository.getCart())
        .flatMap(_updateCart)
        .onSuccess((_) => updateState(HomeScreenState.loaded))
        .recover(_recover);
  }

  Result<Unit> _recover(Exception e) {
    errorMessage = e.toString();
    updateState(HomeScreenState.error);
    return Failure(e);
  }

  Result<Unit> _setItems(List<ItemModel> items) {
    this.items.clear();
    this.items.addAll(items);
    return Success.unit();
  }

  Result<Unit> _updateCart(CartModel cart) {
    this.cart.copyWith(items: cart.items, promoCode: cart.promoCode);
    return Success.unit();
  }

  void updateState(HomeScreenState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> updateCartAndNotifyListeners() async {
    await cartRepository //
        .getCart()
        .flatMap(_updateCart)
        .onSuccess((_) => notifyListeners());
  }

  void updateCartAfterReturningFromCartScreen(CartModel cart) {
    updateState(HomeScreenState.loading);
    _updateCart(cart);
    updateState(HomeScreenState.loaded);
  }

  Future<void> addOrUpdateItemInCart(ItemModel item, int quantity) async {
    final cartItem = CartItemModel(item: item, quantity: quantity);

    if (cart.items.contains(cartItem)) {
      cart.items //
          .firstWhere((e) => e == cartItem)
          .quantity = quantity;
    } else {
      cart.items.add(cartItem);
    }

    await cartRepository //
        .updateCart(cart)
        .fold(
      (success) async => await updateCartAndNotifyListeners(),
      (error) {
        errorMessage = error.toString();
        updateState(HomeScreenState.error);
      },
    );
  }

  Future<void> updateOrRemoveItemFromCart(ItemModel item, int quantity) async {
    final cartItem = CartItemModel(item: item, quantity: quantity);

    if (quantity == 0) {
      cart.items.remove(cartItem);
    } else {
      cart.items //
          .firstWhere((e) => e == cartItem)
          .quantity = quantity;
    }

    await cartRepository //
        .updateCart(cart)
        .fold(
      (success) async => await updateCartAndNotifyListeners(),
      (error) {
        errorMessage = error.toString();
        updateState(HomeScreenState.error);
      },
    );
  }

  int getItemQuantityInCart(ItemModel item) {
    final cartItemModel = cart.items.firstWhere(
      (element) => element.item.id == item.id,
      orElse: () => CartItemModel(item: item, quantity: 0),
    );

    return cartItemModel.quantity;
  }
}

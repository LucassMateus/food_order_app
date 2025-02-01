import 'package:flutter/material.dart';
import 'package:food_order_app/domain/models/cart_item_model.dart';
import 'package:food_order_app/domain/models/cart_model.dart';
import 'package:food_order_app/domain/models/item_model.dart';
import 'package:food_order_app/domain/repositories/cart_repository.dart';

import 'package:food_order_app/domain/repositories/item_repository.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required this.itemRepository, required this.cartRepository});

  @protected
  final ItemRepository itemRepository;
  @protected
  final CartRepository cartRepository;

  final items = <ItemModel>[];
  final CartModel cart = CartModel();

  int get cartTotal => cart //
      .items
      .fold(0, (previousValue, element) => previousValue + element.quantity);

  Future<void> init() async {
    await getItems();
    await updateCartItemModels();

    notifyListeners();
  }

  Future<void> getItems() async {
    final result = await itemRepository.getItems();
    items.addAll(result);
  }

  Future<void> updateCartItemModels() async {
    cart.items.clear();

    final result = await cartRepository.getItems();
    cart.items.addAll(result);
  }

  Future<void> updateCartAndNotifyListeners() async {
    await updateCartItemModels();
    notifyListeners();
  }

  void updateCartAfterReturningFromCartScreen(Set<CartItemModel> items) {
    cart.items.clear();
    cart.items.addAll(items);

    notifyListeners();
  }

  Future<void> addOrUpdateItemInCart(ItemModel item, int quantity) async {
    final cartItemModel = cart.items.firstWhere(
      (element) => element.item.id == item.id,
      orElse: () => CartItemModel(item: item, quantity: 0),
    );

    if (cartItemModel.quantity == 0) {
      final newItem = cartItemModel.copyWith(quantity: quantity);
      await cartRepository.addItem(newItem);
    } else {
      final updatedCartItemModel = cartItemModel.copyWith(quantity: quantity);
      await cartRepository.updateItem(updatedCartItemModel);
    }

    await updateCartAndNotifyListeners();
  }

  Future<void> updateOrRemoveItemFromCart(ItemModel item, int quantity) async {
    if (quantity == 0) {
      await cartRepository.removeItem(item);
    } else {
      final cartItemModel = CartItemModel(item: item, quantity: quantity);
      await cartRepository.updateItem(cartItemModel);
    }

    await updateCartAndNotifyListeners();
  }

  int getItemQuantityInCart(ItemModel item) {
    final cartItemModel = cart.items.firstWhere(
      (element) => element.item.id == item.id,
      orElse: () => CartItemModel(item: item, quantity: 0),
    );

    return cartItemModel.quantity;
  }
}

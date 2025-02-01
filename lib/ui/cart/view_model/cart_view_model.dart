import 'package:flutter/material.dart';
import 'package:food_order_app/domain/models/cart_item_model.dart';
import 'package:food_order_app/domain/models/cart_model.dart';
import 'package:food_order_app/domain/models/cart_summary_model.dart';
import 'package:food_order_app/domain/models/item_model.dart';
import 'package:food_order_app/domain/repositories/cart_repository.dart';
import 'package:food_order_app/domain/use_cases/get_cart_summary_use_case.dart';

class CartViewModel extends ChangeNotifier {
  CartViewModel({
    required this.cartRepository,
    required this.getCartSummaryModelUseCase,
  });

  @protected
  final CartRepository cartRepository;

  @protected
  final GetCartSummaryUseCase getCartSummaryModelUseCase;

  final CartModel cart = CartModel();
  CartSummaryModel cartSummaryModel = CartSummaryModel(
    subTotal: 0,
    promoCodeDiscount: 0,
    delivery: 0,
  );

  Future<void> init() async {
    await _updateCartAndNotifyListeners();
  }

  Future<void> updateCart() async {
    cart.items.clear();
    final result = await cartRepository.getItems();
    cart.items.addAll(result);
  }

  Future<void> updateSummary() async {
    cartSummaryModel = await getCartSummaryModelUseCase(cart);
  }

  Future<void> applyPromoCode(String? promoCode) async {
    cart.promoCode = promoCode ?? '';
    await cartRepository.updatePromoCode(promoCode);
    await updateSummary();

    notifyListeners();
  }

  Future<void> _updateCartAndNotifyListeners() async {
    await updateCart();
    await updateSummary();
    notifyListeners();
  }

  Future<void> updateItemInCart(ItemModel item, int quantity) async {
    try {
      if (quantity == 0) {
        await cartRepository.removeItem(item);
        return;
      }

      await cartRepository
          .updateItem(CartItemModel(item: item, quantity: quantity));
    } finally {
      await _updateCartAndNotifyListeners();
    }
  }
}

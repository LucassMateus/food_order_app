import 'package:flutter/material.dart';
import 'package:food_order_app/domain/models/cart_item_model.dart';
import 'package:food_order_app/domain/models/cart_model.dart';
import 'package:food_order_app/domain/models/cart_summary_model.dart';
import 'package:food_order_app/domain/repositories/promo_code_repository.dart';

class GetCartSummaryModelUseCase {
  @protected
  final PromoCodeRepository promoCodeRepository;

  GetCartSummaryModelUseCase({required this.promoCodeRepository});

  Future<CartSummaryModel> call(CartModel cart) async {
    //TODO: Check promo code
    //TODO: Get delivery value
    //TODO: Calculate total value of the cart
    final promoCode = await promoCodeRepository.getPromoCode(cart.promoCode);

    return CartSummaryModel(
      subTotal: cart.items.fold(0, (total, item) => total + item.value),
      promoCodeDiscount: promoCode?.discount ?? 0,
      delivery: 3.5,
    );
  }
}

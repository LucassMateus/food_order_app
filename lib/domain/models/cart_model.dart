import 'package:food_order_app/domain/models/cart_item_model.dart';
import 'package:food_order_app/domain/models/promo_code_model.dart';

class CartModel {
  Set<CartItemModel> items;
  PromoCodeModel? promoCode;

  CartModel({
    this.promoCode,
    Set<CartItemModel>? items,
  }) : items = items ?? {};

  CartModel.empty() : items = {};

  double get totalValue =>
      items.fold(0, (previousValue, element) => previousValue + element.value);

  void applyPromoCode(PromoCodeModel promoCode) {
    if (promoCode.discount > totalValue) {
      throw Exception('Discount is greater than total value of the cart');
    }

    this.promoCode = promoCode;
  }

  void removePromoCode() {
    promoCode = null;
  }

  CartModel copyWith({
    Set<CartItemModel>? items,
    PromoCodeModel? promoCode,
  }) {
    return CartModel(
      items: items ?? this.items,
      promoCode: promoCode ?? this.promoCode,
    );
  }
}

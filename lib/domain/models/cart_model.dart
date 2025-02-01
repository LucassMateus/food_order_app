import 'package:food_order_app/domain/models/cart_item_model.dart';

class CartModel {
  final Set<CartItemModel> items = {};
  String promoCode = '';

  double get totalValue =>
      items.fold(0, (previousValue, element) => previousValue + element.value);
}

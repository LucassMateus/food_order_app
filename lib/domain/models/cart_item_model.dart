import 'package:food_order_app/domain/models/item_model.dart';

class CartItemModel {
  final ItemModel item;
  int quantity;

  CartItemModel({
    required this.item,
    required this.quantity,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartItemModel && other.item == item;
  }

  @override
  int get hashCode => item.hashCode;

  double get value => item.price * quantity;
}

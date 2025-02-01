import 'package:flutter/material.dart';
import 'package:food_order_app/domain/models/cart_item_model.dart';
import 'package:food_order_app/ui/core/styles/text_styles.dart';
import 'package:food_order_app/domain/models/item_model.dart';
import 'package:food_order_app/ui/core/widgets/food_item_counter.dart';

class CartFoodItemCard extends StatefulWidget {
  const CartFoodItemCard({
    super.key,
    required this.cartItemModel,
    required this.onIncrement,
    required this.onDecrement,
  });

  final CartItemModel cartItemModel;
  final void Function(ItemModel item, int quantity) onIncrement;
  final void Function(ItemModel item, int quantity) onDecrement;

  @override
  State<CartFoodItemCard> createState() => _CartFoodItemCardState();
}

class _CartFoodItemCardState extends State<CartFoodItemCard> {
  CartItemModel get cartItemModel => widget.cartItemModel;
  ItemModel get item => cartItemModel.item;
  int quantity = 0;

  void Function(ItemModel item, int quantity) get onIncrement =>
      widget.onIncrement;
  void Function(ItemModel item, int quantity) get onDecrement =>
      widget.onDecrement;

  @override
  void initState() {
    super.initState();
    quantity = widget.cartItemModel.quantity;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LayoutBuilder(
              builder: (context, constraints) => ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: Container(
                  width: 100,
                  height: constraints.maxHeight,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(item.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: context.textStyles.textBold.copyWith(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  "\$${item.price.toStringAsFixed(2)}",
                  style: context.textStyles.textBold.copyWith(fontSize: 16),
                ),
              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SizedBox(
                child: FoodItemCounter(
                  item: item,
                  initialCounterQuantity: cartItemModel.quantity,
                  onIncrement: onIncrement,
                  onDecrement: onDecrement,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

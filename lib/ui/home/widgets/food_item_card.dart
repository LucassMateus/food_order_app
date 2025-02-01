import 'package:flutter/material.dart';
import 'package:food_order_app/ui/core/styles/text_styles.dart';
import 'package:food_order_app/domain/models/item_model.dart';
import 'package:food_order_app/ui/core/widgets/food_item_counter.dart';

class FoodItemCard extends StatefulWidget {
  const FoodItemCard({
    super.key,
    required this.item,
    this.initialCounterQuantity = 0,
    required this.onIncrement,
    required this.onDecrement,
  });

  final ItemModel item;
  final int initialCounterQuantity;
  final void Function(ItemModel item, int quantity) onIncrement;
  final void Function(ItemModel item, int quantity) onDecrement;

  @override
  State<FoodItemCard> createState() => _FoodItemCardState();
}

class _FoodItemCardState extends State<FoodItemCard> {
  ItemModel get item => widget.item;
  int get initialCounterQuantity => widget.initialCounterQuantity;
  void Function(ItemModel item, int quantity) get onIncrement =>
      widget.onIncrement;
  void Function(ItemModel item, int quantity) get onDecrement =>
      widget.onDecrement;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            LayoutBuilder(
              builder: (context, constraints) => ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: Container(
                  width: 130,
                  height: constraints.maxHeight,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(widget.item.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: context.textStyles.textBold.copyWith(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      item.description,
                      style: context.textStyles.textRegular.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          "\$${item.price.toStringAsFixed(2)}",
                          style: context.textStyles.textBold
                              .copyWith(fontSize: 16),
                        ),
                        Spacer(),
                        FoodItemCounter(
                          item: item,
                          initialCounterQuantity: initialCounterQuantity,
                          onIncrement: onIncrement,
                          onDecrement: onDecrement,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

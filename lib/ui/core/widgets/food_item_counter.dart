import 'package:flutter/material.dart';
import 'package:food_order_app/domain/models/item_model.dart';
import 'package:food_order_app/ui/core/styles/colors_app.dart';

class FoodItemCounter extends StatefulWidget {
  const FoodItemCounter({
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
  State<FoodItemCounter> createState() => _FoodItemCounterState();
}

class _FoodItemCounterState extends State<FoodItemCounter> {
  ItemModel get item => widget.item;
  int quantity = 0;

  void Function(ItemModel item, int quantity) get onIncrement =>
      widget.onIncrement;
  void Function(ItemModel item, int quantity) get onDecrement =>
      widget.onDecrement;

  @override
  void initState() {
    super.initState();
    quantity = widget.initialCounterQuantity;
  }

  @override
  void didUpdateWidget(covariant FoodItemCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCounterQuantity != quantity) {
      setState(() {
        quantity = widget.initialCounterQuantity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: context.colors.secondary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.remove,
                  color: context.colors.primary,
                ),
                onPressed: () {
                  if (quantity > 0) {
                    setState(() {
                      quantity--;
                      onDecrement(item, quantity);
                    });
                  }
                },
              ),
              Text(
                "$quantity",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.add,
                  color: context.colors.primary,
                ),
                onPressed: () {
                  setState(() {
                    quantity++;
                  });
                  onIncrement(item, quantity);
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}

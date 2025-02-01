import 'package:flutter/material.dart';
import 'package:food_order_app/domain/enums/food_category.dart';

class FoodCategoryChip extends StatelessWidget {
  final FoodCategory category;

  const FoodCategoryChip({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
      child: Chip(label: Text(category.text)),
    );
  }
}

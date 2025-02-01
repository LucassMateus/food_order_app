import 'package:food_order_app/domain/enums/food_category.dart';

class ItemModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imagePath;
  final FoodCategory category;

  ItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.category,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ItemModel &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.price == price &&
        other.imagePath == imagePath &&
        other.category == category;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        price.hashCode ^
        imagePath.hashCode ^
        category.hashCode;
  }
}

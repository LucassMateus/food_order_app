import 'package:food_order_app/domain/enums/food_category.dart';
import 'package:food_order_app/domain/models/item_model.dart';
import 'package:food_order_app/domain/repositories/item_repository.dart';
import 'package:result_dart/result_dart.dart';

class ItemRepositoryImpl implements ItemRepository {
  @override
  AsyncResult<ItemModel> getItem(int id) async {
    try {
      final item = items.firstWhere((element) => element.id == id);
      return Success(item);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  @override
  AsyncResult<List<ItemModel>> getItems() async => Success(items);
}

final List<ItemModel> items = [
  ItemModel(
    id: 1,
    name: "Chilli Cheese",
    description: "Delicious cheeseburger topped with spicy chili.",
    price: 15.0,
    imagePath: 'assets/images/chille-cheese.jpg',
    category: FoodCategory.burger,
  ),
  ItemModel(
    id: 2,
    name: "Delish Bloody",
    description: "Refreshing drink with a special Bloody Mary twist.",
    price: 18.0,
    imagePath: 'assets/images/delish-bloody-mary.jpg',
    category: FoodCategory.drink,
  ),
  ItemModel(
    id: 3,
    name: "Lam Burger",
    description: "Juicy lamb burger seasoned with flavorful spices.",
    price: 21.0,
    imagePath: 'assets/images/lam-burger.jpg',
    category: FoodCategory.burger,
  ),
];

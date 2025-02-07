import 'package:flutter/material.dart';

import 'package:food_order_app/domain/enums/food_category.dart';
import 'package:food_order_app/domain/models/cart_model.dart';
import 'package:food_order_app/ui/core/styles/colors_app.dart';
import 'package:food_order_app/ui/core/styles/text_styles.dart';
import 'package:food_order_app/ui/home/view_model/home_view_model.dart';
import 'package:food_order_app/ui/home/widgets/food_category_chip.dart';
import 'package:food_order_app/ui/home/widgets/food_item_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.viewModel,
  });

  final HomeViewModel viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeViewModel get viewModel => widget.viewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.addListener(_listener);
      viewModel.init();
    });
  }

  @override
  void dispose() {
    viewModel.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    if (viewModel.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(viewModel.errorMessage),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.colors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Hello, user!",
                          style: context.textStyles.appBarTitle.copyWith(
                            color: context.colors.secondary,
                          ),
                        ),
                        Spacer(),
                        ListenableBuilder(
                            listenable: viewModel,
                            builder: (context, _) {
                              return FilledButton(
                                onPressed: () async {
                                  final result = await Navigator.of(context)
                                      .pushNamed<CartModel>('/cart');

                                  if (result != null) {
                                    viewModel
                                        .updateCartAfterReturningFromCartScreen(
                                            result);
                                  }
                                },
                                child: Badge.count(
                                  count: viewModel.cartTotal,
                                  child: Icon(
                                    Icons.shopping_cart,
                                    color: context.colors.secondary,
                                    size: 24,
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      "What do you want to eat today?",
                      style: context.textStyles.textRegular.copyWith(
                        color: context.colors.secondary,
                      ),
                    ),
                    SizedBox(height: 16),
                    SearchBar(
                      hintText: "Search for food",
                      leading: Icon(Icons.search),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15),
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: FoodCategory.values
                    .map((category) => FoodCategoryChip(category: category))
                    .toList(),
              ),
            ),
            Expanded(
              child: ListenableBuilder(
                  listenable: viewModel,
                  builder: (context, _) {
                    if (viewModel.isLoading) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(child: CircularProgressIndicator()),
                        ],
                      );
                    }
                    if (viewModel.isLoaded) {
                      return SingleChildScrollView(
                        child: Column(
                          children: viewModel.items
                              .map((item) => FoodItemCard(
                                    item: item,
                                    initialCounterQuantity:
                                        viewModel.getItemQuantityInCart(item),
                                    onDecrement:
                                        viewModel.updateOrRemoveItemFromCart,
                                    onIncrement:
                                        viewModel.addOrUpdateItemInCart,
                                  ))
                              .toList(),
                        ),
                      );
                    }
                    return SizedBox();
                  }),
            )
          ],
        ),
      ),
    );
  }
}

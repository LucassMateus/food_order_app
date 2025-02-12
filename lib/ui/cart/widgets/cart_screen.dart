import 'package:flutter/material.dart';
import 'package:food_order_app/ui/cart/view_model/cart_view_model.dart';
import 'package:food_order_app/ui/cart/widgets/cart_food_item_card.dart';
import 'package:food_order_app/ui/cart/widgets/promo_code_field.dart';
import 'package:food_order_app/ui/core/extensions/double_extension.dart';
import 'package:food_order_app/ui/core/mixins/loader_mixin.dart';
import 'package:food_order_app/ui/core/mixins/message_mixin.dart';
import 'package:food_order_app/ui/core/styles/colors_app.dart';
import 'package:food_order_app/ui/core/styles/text_styles.dart';
import 'package:food_order_app/utils/diposable_page.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, required this.viewModel});

  final CartViewModel viewModel;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends DiposablePage<CartScreen, CartViewModel>
    with LoaderMixin, MessageMixin {
  CartViewModel get viewModel => widget.viewModel;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart', style: context.textStyles.appBarTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, viewModel.cart),
        ),
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.isLoading) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(child: CircularProgressIndicator()),
              ],
            );
          }

          if (viewModel.isLoaded) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ...viewModel.cart.items.map((e) {
                    return CartFoodItemCard(
                      cartItemModel: e,
                      onIncrement: viewModel.updateItemInCart,
                      onDecrement: viewModel.updateItemInCart,
                    );
                  }),
                  Padding(padding: EdgeInsets.only(bottom: 300)),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
      bottomSheet: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            if (!viewModel.isLoaded) return const SizedBox();

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListenableBuilder(
                        listenable: viewModel.applyPromoCodeCommand,
                        builder: (context, _) {
                          return PromoCodeField(
                            onApply: (code) => viewModel //
                                .applyPromoCodeCommand
                                .execute(code),
                            initialValue: viewModel.cart.promoCode?.code,
                            errorMessage: viewModel.promoCodeError,
                            appliedPromoCode: viewModel.cart.promoCode?.code,
                            isRunning:
                                viewModel.applyPromoCodeCommand.isRunning,
                          );
                        }),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('SubTotal:'),
                        Text(viewModel.cart.totalValue.toCurrency()),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Promo Code Discount:'),
                        Text(
                          viewModel.cart.promoCode?.discount.toCurrency() ?? '',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pushNamed(
                          '/checkout',
                          arguments: viewModel.cart,
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: context.colors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Checkout',
                          style: context.textStyles.textButtonLabel.copyWith(
                            color: context.colors.secondary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}

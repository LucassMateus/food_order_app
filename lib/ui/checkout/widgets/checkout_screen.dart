import 'package:flutter/material.dart';
import 'package:food_order_app/domain/enums/payment_type.dart';
import 'package:food_order_app/domain/models/cart_model.dart';
import 'package:food_order_app/ui/checkout/view_model/checkout_view_model.dart';
import 'package:food_order_app/ui/checkout/widgets/payment_method_option.dart';
import 'package:food_order_app/ui/checkout/widgets/shipping_option.dart';
import 'package:food_order_app/ui/core/extensions/double_extension.dart';
import 'package:food_order_app/ui/core/styles/app_styles.dart';
import 'package:food_order_app/ui/core/styles/colors_app.dart';
import 'package:food_order_app/ui/core/styles/text_styles.dart';
import 'package:food_order_app/ui/core/theme/theme_config.dart';

class CheckoutScreen extends StatefulWidget {
  final CheckoutViewModel viewModel;
  const CheckoutScreen({super.key, required this.viewModel});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  CheckoutViewModel get viewModel => widget.viewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.addListener(_listener);
      final cart = ModalRoute.of(context)!.settings.arguments as CartModel;
      viewModel.init(cart);
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
    if (viewModel.isPaymentSuccessful) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Payment successful'),
        backgroundColor: context.colors.primary,
      ));

      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: context.textStyles.appBarTitle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shipping to',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      ...viewModel.address.map((e) {
                        return ShippingOption(
                          address: e,
                          isSelected: viewModel.selectedShippingAddress == e,
                          onChanged: viewModel.setSelectedShipping,
                        );
                      }),
                      Divider(height: 32),
                      Text(
                        'Payment Method',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      ...PaymentType.values.map((e) {
                        return PaymentMethodOption(
                          paymentType: e,
                          isSelected: viewModel.selectedPaymentMethod == e,
                          onChanged: viewModel.setSelectedPaymentMethod,
                        );
                      }),
                      Padding(padding: EdgeInsets.only(bottom: 250)),
                    ],
                  ),
                );
              }
              return SizedBox();
            }),
      ),
      bottomSheet: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            if (!viewModel.isLoaded) {
              return SizedBox();
            }

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('SubTotal:'),
                        Text(viewModel.cart.totalValue.toCurrency()),
                      ],
                    ),
                    Divider(),
                    if (viewModel.hasPromoCode)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Promo code discount:'),
                              Text(
                                viewModel.cartSummary.promoCodeDiscount
                                    .toCurrency(),
                              ),
                            ],
                          ),
                          Divider(),
                        ],
                      ),
                    if (viewModel.hasPaymentDiscount)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Payment discount:'),
                              Text(
                                viewModel.cartSummary.paymentDiscount
                                    .toCurrency(),
                              ),
                            ],
                          ),
                          Divider(),
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Delivery:'),
                        Text(
                          viewModel.cartSummary.deliveryValue.toCurrency(),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total:'),
                        Text(viewModel.cartSummary.total.toCurrency()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => viewModel.confirmPurchase(),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: context.colors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Confirm',
                          style: context.textStyles.textButtonLabel.copyWith(
                            color: Colors.white,
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

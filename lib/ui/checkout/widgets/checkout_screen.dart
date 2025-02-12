import 'package:flutter/material.dart';
import 'package:food_order_app/domain/enums/payment_type.dart';
import 'package:food_order_app/domain/models/cart_model.dart';
import 'package:food_order_app/ui/checkout/view_model/checkout_view_model.dart';
import 'package:food_order_app/ui/checkout/widgets/payment_method_option.dart';
import 'package:food_order_app/ui/checkout/widgets/shipping_option.dart';
import 'package:food_order_app/ui/core/extensions/double_extension.dart';
import 'package:food_order_app/ui/core/mixins/loader_mixin.dart';
import 'package:food_order_app/ui/core/mixins/message_mixin.dart';
import 'package:food_order_app/ui/core/styles/colors_app.dart';
import 'package:food_order_app/ui/core/styles/text_styles.dart';
import 'package:food_order_app/utils/diposable_page.dart';
import 'package:result_command/result_command.dart';

class CheckoutScreen extends StatefulWidget {
  final CheckoutViewModel viewModel;
  const CheckoutScreen({super.key, required this.viewModel});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState
    extends DiposablePage<CheckoutScreen, CheckoutViewModel>
    with LoaderMixin, MessageMixin {
  CheckoutViewModel get viewModel => widget.viewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.addListener(_listener);
      viewModel.confirmPurchaseCommand.addListener(_commandListener);
      final cart = ModalRoute.of(context)!.settings.arguments as CartModel;
      viewModel.init(cart);
    });
  }

  @override
  void dispose() {
    viewModel.removeListener(_listener);
    viewModel.confirmPurchaseCommand.removeListener(_commandListener);
    super.dispose();
  }

  void _listener() {
    if (viewModel.hasError) {
      showErrorMessage(viewModel.errorMessage);
    }

    if (viewModel.paymentState.message.isNotEmpty) {
      hideLoader();
      showLoaderWithMessage(viewModel.paymentState.message);
    }
  }

  void _commandListener() {
    if (viewModel.confirmPurchaseCommand.isIdle) {
      hideLoader();
    }

    if (viewModel.confirmPurchaseCommand.isSuccess) {
      showSuccessMessage('Purchase confirmed!');
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    }

    if (viewModel.confirmPurchaseCommand.isFailure) {
      final failure = viewModel.confirmPurchaseCommand.value as FailureCommand;
      showErrorMessage(failure.error.toString());
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
                    ListenableBuilder(
                        listenable: viewModel.confirmPurchaseCommand,
                        builder: (context, _) {
                          return SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton(
                              onPressed:
                                  viewModel.confirmPurchaseCommand.isRunning
                                      ? null
                                      : () => viewModel //
                                          .confirmPurchaseCommand
                                          .execute(),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: context.colors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                viewModel.confirmPurchaseCommand.isRunning
                                    ? 'Processing...'
                                    : 'Confirm',
                                style:
                                    context.textStyles.textButtonLabel.copyWith(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        })
                  ],
                ),
              ),
            );
          }),
    );
  }
}

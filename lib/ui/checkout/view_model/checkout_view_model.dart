import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_order_app/domain/enums/payment_type.dart';
import 'package:food_order_app/domain/models/address_model.dart';
import 'package:food_order_app/domain/models/cart_model.dart';
import 'package:food_order_app/domain/models/cart_summary_model.dart';
import 'package:food_order_app/domain/repositories/address_repository.dart';
import 'package:food_order_app/domain/use_cases/get_cart_summary_use_case.dart';
import 'package:food_order_app/ui/checkout/state/checkout_screen_state.dart';

class CheckoutViewModel extends ChangeNotifier {
  CheckoutViewModel({
    required this.addressRepository,
    required this.getCartSummaryUseCase,
  });

  @protected
  final AddressRepository addressRepository;
  @protected
  final GetCartSummaryUseCase getCartSummaryUseCase;

  CartModel cart = CartModel.empty();
  CartSummaryModel cartSummary = CartSummaryModel.initial();

  final List<AddressModel> address = [];
  AddressModel? selectedShippingAddress;

  PaymentType selectedPaymentMethod = PaymentType.cash;

  CheckoutScreenState _state = CheckoutScreenState.initial;
  String errorMessage = '';

  bool get isPaymentSuccessful => _state == CheckoutScreenState.paymentSuccess;
  bool get hasError =>
      _state == CheckoutScreenState.error ||
      _state == CheckoutScreenState.paymentError;
  bool get isLoading => _state == CheckoutScreenState.loading;
  bool get isLoaded => _state == CheckoutScreenState.loaded;
  bool get hasPromoCode => cart.promoCode != null;
  bool get hasPaymentDiscount => cartSummary.paymentDiscount > 0;

  Future<void> init(CartModel cart) async {
    updateState(CheckoutScreenState.loading);

    this.cart = cart;

    address.clear();
    address.addAll(await addressRepository.getAll());

    selectedShippingAddress = address.firstOrNull;

    cartSummary = await getCartSummaryUseCase(
      cart,
      selectedShippingAddress,
      selectedPaymentMethod,
    );

    updateState(CheckoutScreenState.loaded);
  }

  void updateState(CheckoutScreenState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> setSelectedShipping(AddressModel? value) async {
    if (value == null) return;

    selectedShippingAddress = value;

    cartSummary = await getCartSummaryUseCase(
      cart,
      selectedShippingAddress,
      selectedPaymentMethod,
    );

    notifyListeners();
  }

  Future<void> setSelectedPaymentMethod(PaymentType? value) async {
    if (value == null) return;

    selectedPaymentMethod = value;
    cartSummary = await getCartSummaryUseCase(
      cart,
      selectedShippingAddress!,
      selectedPaymentMethod,
    );

    notifyListeners();
  }

  Future<void> confirmPurchase() async {
    updateState(CheckoutScreenState.loading);
    try {
      await Future.delayed(const Duration(seconds: 2));

      final isPaymentSuccessful = (selectedPaymentMethod == PaymentType.cash)
          ? true
          : Random().nextBool();

      if (isPaymentSuccessful) {
        updateState(CheckoutScreenState.paymentSuccess);
        return;
      }
      throw Exception('Payment error');
    } catch (e) {
      errorMessage = e.toString();
      updateState(CheckoutScreenState.paymentError);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:food_order_app/domain/enums/payment_type.dart';
import 'package:food_order_app/domain/models/address_model.dart';
import 'package:food_order_app/domain/models/cart_model.dart';
import 'package:food_order_app/domain/models/cart_summary_model.dart';
import 'package:food_order_app/domain/repositories/address_repository.dart';
import 'package:food_order_app/domain/use_cases/get_cart_summary_use_case.dart';
import 'package:food_order_app/domain/use_cases/process_payment_use_case.dart';
import 'package:food_order_app/ui/checkout/state/checkout_screen_state.dart';
import 'package:result_dart/result_dart.dart';

class CheckoutViewModel extends ChangeNotifier {
  CheckoutViewModel({
    required this.addressRepository,
    required this.getCartSummaryUseCase,
    required this.processPaymentUseCase,
  });

  @protected
  final AddressRepository addressRepository;
  @protected
  final GetCartSummaryUseCase getCartSummaryUseCase;
  @protected
  final ProcessPaymentUseCase processPaymentUseCase;

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
    _updateState(CheckoutScreenState.loading);

    this.cart = cart;

    await addressRepository
        .getAll()
        .flatMap(_updateAddress)
        .flatMap(_setInitialSelectedShippingAddress)
        .flatMap(_updateCartSummary)
        .onSuccess(_onSuccess)
        .recover(_recover);

    _updateState(CheckoutScreenState.loaded);
  }

  Result<Unit> _recover(Exception e) {
    errorMessage = e.toString();
    _updateState(CheckoutScreenState.error);
    return Failure(e);
  }

  Result<Unit> _onSuccess(Unit _) {
    _updateState(CheckoutScreenState.loaded);
    return Success(unit);
  }

  Result<Unit> _updateAddress(List<AddressModel> address) {
    this.address.clear();
    this.address.addAll(address);
    return Success(unit);
  }

  Result<Unit> _setInitialSelectedShippingAddress(Unit _) {
    selectedShippingAddress = address.firstOrNull;
    return Success(unit);
  }

  void _updateState(CheckoutScreenState newState) {
    _state = newState;
    notifyListeners();
  }

  AsyncResult<Unit> _updateCartSummary(Unit _) async {
    return await getCartSummaryUseCase(
      cart,
      selectedShippingAddress,
      selectedPaymentMethod,
    ).flatMap((success) {
      cartSummary = success;
      return Success(unit);
    });
  }

  Result<Unit> _notifyListenersOnResult(Unit _) {
    notifyListeners();
    return Success(unit);
  }

  Future<void> setSelectedShipping(AddressModel? value) async {
    if (value == null) return;

    selectedShippingAddress = value;

    await _updateCartSummary(unit).onSuccess(_notifyListenersOnResult);
  }

  Future<void> setSelectedPaymentMethod(PaymentType? value) async {
    if (value == null) return;

    selectedPaymentMethod = value;

    await _updateCartSummary(unit).onSuccess(_notifyListenersOnResult);
  }

  Future<void> confirmPurchase() async {
    _updateState(CheckoutScreenState.loading);

    await processPaymentUseCase(
      paymentType: selectedPaymentMethod,
      paymentValue: cartSummary.total,
    ).fold(_onSuccess, _recover);
  }
}

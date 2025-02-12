import 'package:flutter/material.dart';
import 'package:food_order_app/domain/enums/payment_type.dart';
import 'package:food_order_app/domain/models/address_model.dart';
import 'package:food_order_app/domain/models/cart_model.dart';
import 'package:food_order_app/domain/models/cart_summary_model.dart';
import 'package:food_order_app/domain/repositories/address_repository.dart';
import 'package:food_order_app/domain/use_cases/get_cart_summary_use_case.dart';
import 'package:food_order_app/domain/use_cases/process_payment_use_case.dart';
import 'package:food_order_app/ui/checkout/state/checkout_screen_state.dart';
import 'package:food_order_app/ui/checkout/state/payment_state.dart';
import 'package:food_order_app/utils/disposable_provider.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class CheckoutViewModel extends ChangeNotifier implements DisposableProvider {
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

  late final confirmPurchaseCommand = Command0(_confirmPurchase);

  CartModel cart = CartModel.empty();
  CartSummaryModel cartSummary = CartSummaryModel.initial();

  final List<AddressModel> address = [];
  AddressModel? selectedShippingAddress;

  PaymentType selectedPaymentMethod = PaymentType.cash;

  CheckoutScreenState _state = CheckoutScreenState.initial;
  String errorMessage = '';

  bool get hasError => _state == CheckoutScreenState.error;
  bool get isLoading => _state == CheckoutScreenState.loading;
  bool get isLoaded => _state == CheckoutScreenState.loaded;
  bool get hasPromoCode => cart.promoCode != null;
  bool get hasPaymentDiscount => cartSummary.paymentDiscount > 0;

  PaymentState paymentState = PaymentState.initial;

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

  AsyncResult<Unit> _confirmPurchase() async {
    if (selectedPaymentMethod != PaymentType.cash) {
      paymentState = PaymentState.connectingServer;
      notifyListeners();
      await Future.delayed(Duration(seconds: 1));
    }

    paymentState = PaymentState.processing;
    notifyListeners();
    await Future.delayed(Duration(seconds: 1));
    return processPaymentUseCase(
      paymentType: selectedPaymentMethod,
      paymentValue: cartSummary.total,
    ).fold(_onPaymentSuccess, _onPaymentError);
  }

  Result<Unit> _onPaymentSuccess(Unit _) {
    paymentState = PaymentState.success;
    notifyListeners();

    return Success(unit);
  }

  Result<Unit> _onPaymentError(Exception e) {
    paymentState = PaymentState.error;
    errorMessage = e.toString();
    notifyListeners();

    return Success(unit);
  }

  @override
  void disposeValues() {
    cart = CartModel.empty();
    cartSummary = CartSummaryModel.initial();
    address.clear();
    selectedShippingAddress = null;
    selectedPaymentMethod = PaymentType.cash;
    paymentState = PaymentState.initial;
    errorMessage = '';
  }
}

import 'package:flutter/material.dart';
import 'package:food_order_app/domain/enums/payment_type.dart';
import 'package:food_order_app/domain/factory/payment_factory.dart';
import 'package:food_order_app/domain/models/address_model.dart';
import 'package:food_order_app/domain/models/cart_model.dart';
import 'package:food_order_app/domain/models/cart_summary_model.dart';
import 'package:food_order_app/domain/repositories/delivery_details_repository.dart';
import 'package:food_order_app/domain/repositories/promo_code_repository.dart';
import 'package:result_dart/result_dart.dart';

class GetCartSummaryUseCase {
  GetCartSummaryUseCase({
    required this.promoCodeRepository,
    required this.deliveryDetailsRepository,
  });

  @protected
  final PromoCodeRepository promoCodeRepository;

  @protected
  final DeliveryDetailsRepository deliveryDetailsRepository;

  AsyncResult<CartSummaryModel> call(
    CartModel cart,
    AddressModel? address,
    PaymentType paymentType,
  ) async {
    if (cart.promoCode != null) {
      await promoCodeRepository //
          .getPromoCode(cart.promoCode?.code ?? '')
          .getOrThrow();
    }

    final deliveryDetails = await deliveryDetailsRepository //
        .get()
        .getOrThrow();

    final paymentValue = cart.totalValue - (cart.promoCode?.discount ?? 0);
    final payment = PaymentFactory.create(paymentType, paymentValue);
    final double deliveryValue = (address == null)
        ? 0
        : deliveryDetails.calculatePrice(address.distance);

    return Success(CartSummaryModel(
      subTotal: cart.totalValue,
      promoCodeDiscount: cart.promoCode?.discount ?? 0,
      paymentDiscount: payment.discount,
      deliveryValue: deliveryValue,
    ));
  }
}

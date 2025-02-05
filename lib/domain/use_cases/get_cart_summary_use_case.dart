import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_order_app/domain/enums/payment_type.dart';
import 'package:food_order_app/domain/factory/payment_factory.dart';
import 'package:food_order_app/domain/models/address_model.dart';
import 'package:food_order_app/domain/models/cart_model.dart';
import 'package:food_order_app/domain/models/cart_summary_model.dart';
import 'package:food_order_app/domain/models/payments/cash_payment.dart';
import 'package:food_order_app/domain/models/payments/payment.dart';
import 'package:food_order_app/domain/repositories/delivery_details_repository.dart';
import 'package:food_order_app/domain/repositories/promo_code_repository.dart';

final deliveryDistance = Random().nextDouble() * 10;

class GetCartSummaryUseCase {
  GetCartSummaryUseCase({
    required this.promoCodeRepository,
    required this.deliveryDetailsRepository,
  });

  @protected
  final PromoCodeRepository promoCodeRepository;

  @protected
  final DeliveryDetailsRepository deliveryDetailsRepository;

  Future<CartSummaryModel> call(
    CartModel cart,
    AddressModel? address,
    PaymentType paymentType,
  ) async {
    final deliveryDetails = await deliveryDetailsRepository.get();
    final paymentValue = cart.totalValue - (cart.promoCode?.discount ?? 0);
    final payment = PaymentFactory.create(paymentType, paymentValue);
    final double deliveryValue = (address == null)
        ? 0
        : deliveryDetails.calculatePrice(address.distance);

    return CartSummaryModel(
      subTotal: cart.totalValue,
      promoCodeDiscount: cart.promoCode?.discount ?? 0,
      paymentDiscount: payment.discount,
      deliveryValue: deliveryValue,
    );
  }
}

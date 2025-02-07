import 'package:flutter/material.dart';
import 'package:food_order_app/data/payment_facade.dart';
import 'package:food_order_app/domain/enums/payment_type.dart';
import 'package:food_order_app/domain/factory/payment_factory.dart';
import 'package:food_order_app/domain/repositories/cart_repository.dart';
import 'package:result_dart/result_dart.dart';

class ProcessPaymentUseCase {
  ProcessPaymentUseCase({required this.cartRepository});

  @protected
  final CartRepository cartRepository;

  AsyncResult<Unit> call({
    required PaymentType paymentType,
    required double paymentValue,
  }) async {
    final payment = PaymentFactory.create(paymentType, paymentValue);

    return await PaymentFacade(payment: payment)
        .processPayment()
        .flatMap(_cartCheckout)
        .recover(_recover);
  }

  AsyncResult<Unit> _cartCheckout(Unit u) async {
    return await cartRepository.checkout();
  }

  AsyncResult<Unit> _recover(Exception e) async {
    return Failure(e);
  }
}

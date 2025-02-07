import 'package:food_order_app/domain/enums/payment_type.dart';
import 'package:food_order_app/domain/payments/apple_pay_payment.dart';
import 'package:food_order_app/domain/payments/cash_payment.dart';
import 'package:food_order_app/domain/payments/credit_card_payment.dart';
import 'package:food_order_app/domain/payments/google_pay_payment.dart';
import 'package:food_order_app/domain/payments/payment.dart';
import 'package:food_order_app/domain/payments/paypal_payment.dart';

class PaymentFactory {
  static Payment create(PaymentType paymentType, double value) {
    switch (paymentType) {
      case PaymentType.cash:
        return CashPayment(value: value);
      case PaymentType.creditCard:
        return CreditCardPayment(value: value);
      case PaymentType.paypal:
        return PaypalPayment(value: value);
      case PaymentType.applePay:
        return ApplePayPayment(value: value);
      case PaymentType.googlePay:
        return GooglePayPayment(value: value);
    }
  }
}

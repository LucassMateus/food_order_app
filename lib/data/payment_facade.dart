import 'package:flutter/material.dart';
import 'package:food_order_app/domain/payments/apple_pay_payment.dart';
import 'package:food_order_app/domain/payments/cash_payment.dart';
import 'package:food_order_app/domain/payments/credit_card_payment.dart';
import 'package:food_order_app/domain/payments/google_pay_payment.dart';
import 'package:food_order_app/domain/payments/payment.dart';
import 'package:food_order_app/domain/payments/paypal_payment.dart';
import 'package:result_dart/result_dart.dart';

class PaymentFacade {
  PaymentFacade({required Payment payment}) : _payment = payment;

  @protected
  final Payment _payment;

  AsyncResult<Unit> processPayment() async {
    try {
      switch (_payment.runtimeType) {
        case const (CashPayment):
          debugPrint(
              'Pagamento no valor de \$${_payment.value.toStringAsFixed(2)} aprovado com dinheiro.');
          break;

        case const (CreditCardPayment):
          debugPrint('Conectando ao servidor...');
          await Future.delayed(const Duration(milliseconds: 500));
          debugPrint('Processando pagamento...');
          await Future.delayed(const Duration(milliseconds: 1000));
          debugPrint('Pagamento aprovado no cartão de crédito.');
          break;

        case const (GooglePayPayment):
          debugPrint('Inicializando Google Pay...');
          await Future.delayed(const Duration(milliseconds: 500));
          debugPrint('Autenticando usuário...');
          await Future.delayed(const Duration(milliseconds: 300));
          debugPrint('Pagamento aprovado via Google Pay.');
          break;

        case const (ApplePayPayment):
          debugPrint('Verificando biometria...');
          await Future.delayed(const Duration(milliseconds: 500));
          debugPrint('Pagamento aprovado via Apple Pay.');
          break;

        case const (PaypalPayment):
          debugPrint('Conectando ao PayPal...');
          await Future.delayed(const Duration(milliseconds: 500));
          debugPrint('Autenticando usuário...');
          await Future.delayed(const Duration(milliseconds: 300));
          debugPrint('Pagamento aprovado pelo PayPal.');
          break;

        default:
          throw Exception('Método de pagamento não suportado.');
      }

      return Success.unit();
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}

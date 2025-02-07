import 'package:food_order_app/domain/payments/payment.dart';

class CashPayment extends Payment {
  CashPayment({required super.value});

  @override
  double get discount => super.value * 0.1;

  @override
  double get totalValue => super.value - discount;
}

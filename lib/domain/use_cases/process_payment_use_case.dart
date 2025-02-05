import 'package:food_order_app/domain/models/payments/payment.dart';

class ProcessPaymentUseCase {
  Future<void> call(Payment payment) async {
    await Future.delayed(Duration(seconds: 1));
  }
}

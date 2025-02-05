import 'package:flutter/material.dart';
import 'package:food_order_app/domain/enums/payment_type.dart';

class PaymentMethodOption extends StatelessWidget {
  final PaymentType paymentType;
  final bool isSelected;
  final void Function(PaymentType? value)? onChanged;

  const PaymentMethodOption({
    super.key,
    required this.paymentType,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<PaymentType>(
      title: Row(
        children: [
          paymentType.icon,
          SizedBox(width: 8),
          Text(paymentType.text),
        ],
      ),
      value: paymentType,
      groupValue: isSelected ? paymentType : null,
      onChanged: onChanged,
    );
  }
}

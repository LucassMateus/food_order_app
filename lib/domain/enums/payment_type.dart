import 'package:flutter/material.dart';

enum PaymentType {
  cash('Cash', Icon(Icons.payments)),
  creditCard('Credit card', Icon(Icons.credit_card)),
  paypal('PayPal', Icon(Icons.paypal)),
  googlePay('Google Pay', Icon(Icons.account_balance_wallet)),
  applePay('Apple Pay', Icon(Icons.apple));

  final String text;
  final Icon icon;

  const PaymentType(this.text, this.icon);
}

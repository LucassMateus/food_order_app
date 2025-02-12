enum PaymentState {
  initial(''),
  connectingServer('Connecting to server...'),
  processing('Processing...'),
  success('Payment successful'),
  error('Payment failed');

  final String message;
  const PaymentState(this.message);
}

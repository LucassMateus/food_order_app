import 'package:flutter/material.dart';
import 'package:food_order_app/ui/core/styles/text_styles.dart';

mixin LoaderMixin<T extends StatefulWidget> on State<T> {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void showLoader() {
    if (_isLoading) return;

    _isLoading = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }

  void showLoaderWithMessage(String message) {
    if (_isLoading) return;

    _isLoading = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Row(
          children: [
            const CircularProgressIndicator.adaptive(),
            const SizedBox(width: 16),
            Text(
              message,
              style: context.textStyles.textBold.copyWith(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void hideLoader() {
    if (!_isLoading) return;

    _isLoading = false;

    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  }
}

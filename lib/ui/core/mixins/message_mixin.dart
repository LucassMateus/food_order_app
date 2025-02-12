import 'package:flutter/material.dart';
import 'package:food_order_app/ui/core/theme/theme_config.dart';

mixin MessageMixin<T extends StatefulWidget> on State<T> {
  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ThemeConfig.theme.colorScheme.error,
      ),
    );
  }

  void showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ThemeConfig.theme.colorScheme.primary,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:food_order_app/ui/core/styles/text_styles.dart';

import 'colors_app.dart';

class AppStyles {
  static AppStyles? _instance;

  AppStyles._();

  static AppStyles get instance => _instance ??= AppStyles._();

  ButtonStyle get primaryButton => ElevatedButton.styleFrom(
        textStyle: TextStyles.instance.textRegular.copyWith(
          color: Colors.white,
        ),
        backgroundColor: ColorsApp.instance.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      );
}

extension AppStylesExtension on BuildContext {
  AppStyles get appStyles => AppStyles.instance;
}

import 'package:flutter/material.dart';
import 'package:food_order_app/config/dependencies.dart';
import 'package:food_order_app/domain/models/cart_model.dart';
import 'package:food_order_app/ui/cart/widgets/cart_screen.dart';
import 'package:food_order_app/ui/checkout/widgets/checkout_screen.dart';
import 'package:food_order_app/ui/core/theme/theme_config.dart';
import 'package:food_order_app/ui/home/widgets/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeConfig.theme,
        initialRoute: '/home',
        onGenerateRoute: (settings) {
          if (settings.name == '/home') {
            return MaterialPageRoute(
              builder: (context) => HomeScreen(
                viewModel: context.read(),
              ),
            );
          }
          if (settings.name == '/cart') {
            return MaterialPageRoute<CartModel>(
              builder: (context) => CartScreen(
                viewModel: context.read(),
              ),
            );
          }
          if (settings.name == '/checkout') {
            return MaterialPageRoute(
              builder: (context) => CheckoutScreen(
                viewModel: context.read(),
              ),
              settings: settings,
            );
          }
          return null;
        },
      ),
    );
  }
}

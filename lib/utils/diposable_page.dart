import 'package:flutter/material.dart';
import 'package:food_order_app/utils/disposable_provider.dart';
import 'package:provider/provider.dart';

abstract class DiposablePage<T extends StatefulWidget,
    C extends DisposableProvider> extends State<T> {
  C get viewModel => context.read<C>();

  @override
  void dispose() {
    viewModel.disposeValues();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:food_order_app/utils/disposable_provider.dart';
import 'package:provider/provider.dart';

abstract class DiposablePage<T extends StatefulWidget,
    C extends DisposableProvider> extends State<T> {
  C? _viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewModel ??= context.read<C>();
  }

  @override
  void dispose() {
    _viewModel?.disposeValues();
    super.dispose();
  }
}

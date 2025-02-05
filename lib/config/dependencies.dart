import 'package:food_order_app/data/repositories/address_repository_impl.dart';
import 'package:food_order_app/data/repositories/cart_repository_impl.dart';
import 'package:food_order_app/data/repositories/delivery_details_repository_impl.dart';
import 'package:food_order_app/data/repositories/promo_code_repository_impl.dart';
import 'package:food_order_app/domain/repositories/address_repository.dart';
import 'package:food_order_app/domain/repositories/cart_repository.dart';
import 'package:food_order_app/domain/repositories/delivery_details_repository.dart';
import 'package:food_order_app/domain/repositories/promo_code_repository.dart';
import 'package:food_order_app/domain/use_cases/get_cart_summary_use_case.dart';
import 'package:food_order_app/ui/cart/view_model/cart_view_model.dart';
import 'package:food_order_app/ui/checkout/view_model/checkout_view_model.dart';
import 'package:food_order_app/ui/home/view_model/home_view_model.dart';
import 'package:provider/provider.dart';
import 'package:food_order_app/domain/repositories/item_repository.dart';
import 'package:provider/single_child_widget.dart';

import '../data/repositories/item_repository_impl.dart';

List<SingleChildWidget> providers = [
  Provider<ItemRepository>(create: (_) => ItemRepositoryImpl()),
  Provider<CartRepository>(create: (_) => CartRepositoryImpl()),
  Provider<PromoCodeRepository>(create: (_) => PromoCodeRepositoryImpl()),
  Provider<AddressRepository>(create: (_) => AddressRepositoryImpl()),
  Provider<DeliveryDetailsRepository>(
    create: (_) => DeliveryDetailsRepositoryImpl(),
  ),
  Provider<GetCartSummaryUseCase>(
    create: (context) => GetCartSummaryUseCase(
      promoCodeRepository: context.read(),
      deliveryDetailsRepository: context.read(),
    ),
  ),
  ChangeNotifierProvider(
    create: (context) => HomeViewModel(
      itemRepository: context.read(),
      cartRepository: context.read(),
    ),
  ),
  ChangeNotifierProvider(
    create: (context) => CartViewModel(
      cartRepository: context.read(),
      promoCodeRepository: context.read(),
    ),
  ),
  ChangeNotifierProvider(
    create: (context) => CheckoutViewModel(
      addressRepository: context.read(),
      getCartSummaryUseCase: context.read(),
    ),
  )
];

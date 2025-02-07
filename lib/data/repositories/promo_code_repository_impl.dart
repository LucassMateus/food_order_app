import 'package:food_order_app/domain/models/promo_code_model.dart';
import 'package:food_order_app/domain/repositories/promo_code_repository.dart';
import 'package:result_dart/result_dart.dart';

class PromoCodeRepositoryImpl implements PromoCodeRepository {
  static final List<PromoCodeModel> _promoCodes = [
    PromoCodeModel(code: 'PROMO1', discount: 10),
    PromoCodeModel(code: 'PROMO2', discount: 20),
    PromoCodeModel(code: 'PROMO3', discount: 30),
  ];

  @override
  AsyncResult<PromoCodeModel> getPromoCode(String code) async {
    try {
      final promoCode = _promoCodes //
          .firstWhere((element) => element.code == code);
      return Success(promoCode);
    } on Exception {
      return Failure(Exception('Invalid promo code'));
    }
  }

  @override
  AsyncResult<List<PromoCodeModel>> getPromoCodes() async =>
      Success(_promoCodes);
}

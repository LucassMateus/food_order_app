import 'package:food_order_app/domain/models/promo_code_model.dart';
import 'package:food_order_app/domain/repositories/promo_code_repository.dart';

class PromoCodeRepositoryImpl implements PromoCodeRepository {
  static final List<PromoCodeModel> _promoCodes = [
    PromoCodeModel(code: 'PROMO1', discount: 10),
    PromoCodeModel(code: 'PROMO2', discount: 20),
    PromoCodeModel(code: 'PROMO3', discount: 30),
  ];

  @override
  Future<PromoCodeModel?> getPromoCode(String code) async {
    try {
      return _promoCodes.firstWhere((element) => element.code == code);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<PromoCodeModel>> getPromoCodes() {
    return Future.value(_promoCodes);
  }
}

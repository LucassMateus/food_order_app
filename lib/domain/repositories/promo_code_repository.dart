import 'package:food_order_app/domain/models/promo_code_model.dart';

abstract interface class PromoCodeRepository {
  Future<PromoCodeModel?> getPromoCode(String code);
  Future<List<PromoCodeModel>> getPromoCodes();
}

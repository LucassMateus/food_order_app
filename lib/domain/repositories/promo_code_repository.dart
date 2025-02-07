import 'package:food_order_app/domain/models/promo_code_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class PromoCodeRepository {
  AsyncResult<PromoCodeModel> getPromoCode(String code);
  AsyncResult<List<PromoCodeModel>> getPromoCodes();
}

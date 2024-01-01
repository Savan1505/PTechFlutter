import 'package:ptecpos_mobile/core/utils/res_default_model.dart';
import 'package:ptecpos_mobile/features/home/modules/price/datasource/price_level_datasource.dart';
import 'package:ptecpos_mobile/features/home/modules/price/model/req_price_level_model.dart';
import 'package:ptecpos_mobile/features/home/modules/price/model/res_price_level_model.dart';
import 'package:ptecpos_mobile/features/home/modules/price/model/res_price_model.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/model/req_delete_trigger_model.dart';

class PriceLevelRepo {
  final PriceLevelDatasource _datasource = PriceLevelDatasource();

  Stream<ResPriceLevelModel> getPriceLevel(int pageSize, int pageNumber) {
    return _datasource.getPriceLevel(pageSize, pageNumber);
  }

  Stream<ResPriceLevelModel> getSearchedPriceLevel(int pageSize, int pageNumber, String name) {
    return _datasource.getSearchedPriceLevel(pageSize, pageNumber, name);
  }

  Stream<ResPriceModel> addPriceLevel(ReqPriceLevelModel model) {
    return _datasource.addPriceLevel(model);
  }

  Stream<ResPriceModel> getPriceLevelById(String id) {
    return _datasource.getPriceLevelById(id);
  }

  Stream<ResDefaultModel> editPriceLevel(ReqPriceLevelModel model, String id) {
    return _datasource.editPriceLevel(model, id);
  }

  Stream<ResDefaultModel> deletePriceLevel(String id, ReqCrudOperationModel model) {
    return _datasource.deletePriceLevel(id, model);
  }
}

import 'package:ptecpos_mobile/core/utils/res_default_model.dart';
import 'package:ptecpos_mobile/features/home/modules/discount/datasource/standard_discount_datasource.dart';
import 'package:ptecpos_mobile/features/home/modules/discount/model/req_edit_standard_model.dart';
import 'package:ptecpos_mobile/features/home/modules/discount/model/req_standard_model.dart';
import 'package:ptecpos_mobile/features/home/modules/discount/model/res_standard_detail_model.dart';
import 'package:ptecpos_mobile/features/home/modules/discount/model/res_standard_discount_model.dart';
import 'package:ptecpos_mobile/features/home/modules/discount/model/res_standard_model.dart';
import 'package:ptecpos_mobile/features/home/modules/discount/model/res_standard_store_model.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/model/req_delete_trigger_model.dart';

class StandardDiscountRepo {
  final StandardDiscountDatasource _datasource = StandardDiscountDatasource();

  Stream<ResStandardDiscountModel> getStandardDiscount(int pageSize, int pageNumber) {
    return _datasource.getStandardDiscount(pageSize, pageNumber);
  }

  Stream<ResStandardDiscountModel> getSearchedStandardDiscount(
    int pageSize,
    int pageNumber,
    String name,
  ) {
    return _datasource.getSearchedStandardDiscount(pageSize, pageNumber, name);
  }

  Stream<ResStandardStoresModel> getStandardStores() {
    return _datasource.getStandardStores();
  }

  Stream<ResStandardModel> postStandard(ReqStandardModel model) {
    return _datasource.postStandard(model);
  }

  Stream<ResDefaultModel> deleteStandard(String id, ReqCrudOperationModel model) {
    return _datasource.deleteStandard(id, model);
  }

  Stream<ResStandardDetailModel> getStandard(String id) {
    return _datasource.getStandard(id);
  }

  Stream<ResDefaultModel> editStandard(ReqEditStandardModel model) {
    return _datasource.editStandard(model);
  }
}

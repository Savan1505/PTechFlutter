import 'package:ptecpos_mobile/core/domain/datasource/api_manager.dart';
import 'package:ptecpos_mobile/core/root/root_bloc.dart';
import 'package:ptecpos_mobile/core/utils/api_constants.dart';
import 'package:ptecpos_mobile/core/utils/res_default_model.dart';
import 'package:ptecpos_mobile/features/home/modules/discount/model/req_edit_standard_model.dart';
import 'package:ptecpos_mobile/features/home/modules/discount/model/req_standard_model.dart';
import 'package:ptecpos_mobile/features/home/modules/discount/model/res_standard_detail_model.dart';
import 'package:ptecpos_mobile/features/home/modules/discount/model/res_standard_discount_model.dart';
import 'package:ptecpos_mobile/features/home/modules/discount/model/res_standard_model.dart';
import 'package:ptecpos_mobile/features/home/modules/discount/model/res_standard_store_model.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/model/req_delete_trigger_model.dart';

class StandardDiscountDatasource {
  Stream<ResStandardDiscountModel> getStandardDiscount(int pageSize, int pageNumber) {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.standardDiscountApi,
        queryParameters: {
          "IncludeInactive": false,
          "PageSize": pageSize,
          "PageNumber": pageNumber,
          "Usage": 0,
          "strid": RootBloc.store?.id,
        },
      ),
    ).map((event) => ResStandardDiscountModel.fromJson(event.data));
  }

  Stream<ResStandardDiscountModel> getSearchedStandardDiscount(
    int pageSize,
    int pageNumber,
    String name,
  ) {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.standardDiscountApi,
        queryParameters: {
          "IncludeInactive": false,
          "PageSize": pageSize,
          "PageNumber": pageNumber,
          "Usage": 0,
          "strid": RootBloc.store?.id,
          "nm": name,
        },
      ),
    ).map((event) => ResStandardDiscountModel.fromJson(event.data));
  }

  Stream<ResStandardStoresModel> getStandardStores() {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.getStandardStores,
        queryParameters: {
          "IncludeInactive": false,
          "PageSize": 10000,
          "PageNumber": 1,
          "Usage": 1,
        },
      ),
    ).map((event) => ResStandardStoresModel.fromJson(event.data));
  }

  Stream<ResStandardModel> postStandard(ReqStandardModel model) {
    return Stream.fromFuture(
      ApiManager().dio()!.post(ApiConstants.standardDiscountApi, data: model.toJson()),
    ).map((event) => ResStandardModel.fromJson(event.data));
  }

  Stream<ResDefaultModel> deleteStandard(String id, ReqCrudOperationModel model) {
    return Stream.fromFuture(
      ApiManager().dio()!.patch("${ApiConstants.standardDiscountApi}/$id", data: [model.toJson()]),
    ).map((event) => ResDefaultModel.fromJson(event.data));
  }

  Stream<ResStandardDetailModel> getStandard(String id) {
    return Stream.fromFuture(
      ApiManager().dio()!.get("${ApiConstants.standardDiscountApi}/$id"),
    ).map((event) => ResStandardDetailModel.fromJson(event.data));
  }

  Stream<ResDefaultModel> editStandard(ReqEditStandardModel model) {
    return Stream.fromFuture(
      ApiManager().dio()!.put("${ApiConstants.standardDiscountApi}/${model.id}", data: model.toJson()),
    ).map((event) => ResDefaultModel.fromJson(event.data));
  }
}

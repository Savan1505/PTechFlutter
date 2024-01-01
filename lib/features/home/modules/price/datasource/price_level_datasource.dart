import 'package:ptecpos_mobile/core/domain/datasource/api_manager.dart';
import 'package:ptecpos_mobile/core/root/root_bloc.dart';
import 'package:ptecpos_mobile/core/utils/api_constants.dart';
import 'package:ptecpos_mobile/core/utils/res_default_model.dart';
import 'package:ptecpos_mobile/features/home/modules/price/model/req_price_level_model.dart';
import 'package:ptecpos_mobile/features/home/modules/price/model/res_price_level_model.dart';
import 'package:ptecpos_mobile/features/home/modules/price/model/res_price_model.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/model/req_delete_trigger_model.dart';

class PriceLevelDatasource {
  Stream<ResPriceLevelModel> getPriceLevel(int pageSize, int pageNumber) {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.priceLevelApi,
        queryParameters: {
          "IncludeInactive": false,
          "PageSize": pageSize,
          "PageNumber": pageNumber,
          "Usage": 0,
          "StoreID": RootBloc.store?.id,
          "SortColumn": "UpdatedOn Desc",
        },
      ),
    ).map((event) => ResPriceLevelModel.fromJson(event.data));
  }

  Stream<ResPriceLevelModel> getSearchedPriceLevel(int pageSize, int pageNumber, String name) {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.priceLevelApi,
        queryParameters: {
          "IncludeInactive": false,
          "PageSize": pageSize,
          "PageNumber": pageNumber,
          "Usage": 0,
          "StoreID": RootBloc.store?.id,
          "SortColumn": "UpdatedOn Desc",
          "Name": name,
        },
      ),
    ).map((event) => ResPriceLevelModel.fromJson(event.data));
  }

  Stream<ResPriceModel> addPriceLevel(ReqPriceLevelModel model) {
    return Stream.fromFuture(ApiManager().dio()!.post(ApiConstants.priceLevelApi, data: model.toJson()))
        .map((event) => ResPriceModel.fromJson(event.data));
  }

  Stream<ResPriceModel> getPriceLevelById(String id) {
    return Stream.fromFuture(ApiManager().dio()!.get("${ApiConstants.priceLevelApi}/$id"))
        .map((event) => ResPriceModel.fromJson(event.data));
  }

  Stream<ResDefaultModel> editPriceLevel(ReqPriceLevelModel model, String id) {
    return Stream.fromFuture(
      ApiManager().dio()!.put("${ApiConstants.priceLevelApi}/$id", data: model.toJson()),
    ).map((event) => ResDefaultModel.fromJson(event.data));
  }

  Stream<ResDefaultModel> deletePriceLevel(String id, ReqCrudOperationModel model) {
    return Stream.fromFuture(
      ApiManager().dio()!.patch("${ApiConstants.priceLevelApi}/$id", data: [model.toJson()]),
    ).map((event) => ResDefaultModel.fromJson(event.data));
  }
}

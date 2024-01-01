import 'package:ptecpos_mobile/core/domain/datasource/api_manager.dart';
import 'package:ptecpos_mobile/core/root/root_bloc.dart';
import 'package:ptecpos_mobile/core/utils/api_constants.dart';
import 'package:ptecpos_mobile/core/utils/res_default_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_storeitem_model.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/model/req_delete_trigger_model.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/model/req_trigger_model.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/model/req_trigger_update_model.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/model/res_trigger_model.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/model/res_trigger_update_model.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/model/res_triggerpost_model.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/model/res_trptriggers_model.dart';

class TprDatasource {
  Stream<ResTriggerModel> getTriggers(int pageSize, int pageNumber) {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.getTpr,
        queryParameters: {
          "IncludeInactive": false,
          "PageSize": pageSize,
          "PageNumber": pageNumber,
          "Usage": 0,
          "IsExpired": false,
          "StoreID": RootBloc.store?.id,
        },
      ),
    ).map((event) => ResTriggerModel.fromJson(event.data));
  }

  Stream<ResTriggerModel> getFilterTriggers({
    required int pageSize,
    required int pageNumber,
    String? startDate,
    String? endDate,
    int? type,
  }) {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.getTpr,
        queryParameters: {
          "IncludeInactive": false,
          "PageSize": pageSize,
          "PageNumber": pageNumber,
          "Usage": 0,
          "IsExpired": false,
          "StoreID": RootBloc.store?.id,
          "Sdt": startDate,
          "Edt": endDate,
          "Type": type,
        },
      ),
    ).map((event) => ResTriggerModel.fromJson(event.data));
  }

  Stream<ResStoreItemModel> getStoreItem() {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.storeItemApi,
        queryParameters: {
          "Usage": 1,
          "StoreID": RootBloc.store?.id,
          "IncludeInactive": false,
          "PageNumber": 1,
          "PageSize": 10000,
        },
      ),
    ).map((event) => ResStoreItemModel.fromJson(event.data));
  }

  Stream<ResTrpTriggersModel> getTriggerPackage(String storeItemId) {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.getTriggersStoreItemPackage,
        queryParameters: {
          "Usage": 0,
          "StoreID": RootBloc.store?.id,
          "IncludeInactive": false,
          "PageNumber": 1,
          "PageSize": 10000,
          "StoreItemID": storeItemId,
        },
      ),
    ).map((event) => ResTrpTriggersModel.fromJson(event.data));
  }

  Stream<ResTriggerModel> getPackageTrigger({required String storeItemId, String? packageId}) {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.getTriggersStoreItemPackage,
        queryParameters: {
          "Usage": 0,
          "StoreID": RootBloc.store?.id,
          "IncludeInactive": false,
          "PageNumber": 1,
          "PageSize": 10000,
          "StoreItemID": storeItemId,
          "PackageID": packageId,
        },
      ),
    ).map((event) => ResTriggerModel.fromJson(event.data));
  }

  Stream<ResTriggerPostModel> postTrigger(ReqTriggerModel model) {
    return Stream.fromFuture(
      ApiManager().dio()!.post(ApiConstants.getTriggersStoreItemPackage, data: model.toJson()),
    ).map((event) => ResTriggerPostModel.fromJson(event.data));
  }

  Stream<ResDefaultModel> updateTrigger(ReqTriggerUpdateModel model, String id) {
    return Stream.fromFuture(
      ApiManager().dio()!.put("${ApiConstants.getTriggersStoreItemPackage}/$id", data: model.toJson()),
    ).map((event) => ResDefaultModel.fromJson(event.data));
  }

  Stream<ResTriggerUpdateModel> getTrigger(String id) {
    return Stream.fromFuture(
      ApiManager().dio()!.get("${ApiConstants.getTriggersStoreItemPackage}/$id"),
    ).map((event) => ResTriggerUpdateModel.fromJson(event.data));
  }

  Stream<ResDefaultModel> deleteTrigger(String id, ReqCrudOperationModel model) {
    return Stream.fromFuture(
      ApiManager().dio()!.patch(
        "${ApiConstants.getTriggersStoreItemPackage}/$id",
        data: [model.toJson()],
      ),
    ).map((event) => ResDefaultModel.fromJson(event.data));
  }
}

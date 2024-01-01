import 'package:ptecpos_mobile/core/domain/datasource/api_manager.dart';
import 'package:ptecpos_mobile/core/root/root_bloc.dart';
import 'package:ptecpos_mobile/core/utils/api_constants.dart';
import 'package:ptecpos_mobile/core/utils/flavors.dart';
import 'package:ptecpos_mobile/core/utils/res_default_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_category_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_department_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_storeitem_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_sub_category_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/accessGroup/model/req_access_group_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/accessGroup/model/res_access_group_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/accessGroup/model/res_access_model.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/model/req_delete_trigger_model.dart';

class AccessDatasource {
  Stream<ResAccessGroupModel> getAccessGroup(int pageSize, int pageNumber) {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.getQuickAccess,
        queryParameters: {
          "IncludeInactive": false,
          "PageSize": pageSize,
          "PageNumber": pageNumber,
          "Usage": 1,
          "Favorite": true,
          "StoreID": RootBloc.store?.id,
        },
      ),
    ).map((event) => ResAccessGroupModel.fromJson(event.data));
  }

  Stream<ResAccessGroupModel> getFilteredAccessGroup({
    required int pageSize,
    required int pageNumber,
    bool? inActive,
    String? name,
  }) {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.getQuickAccess,
        queryParameters: {
          "IncludeInactive": inActive,
          "PageSize": pageSize,
          "PageNumber": pageNumber,
          "Usage": 1,
          "Favorite": true,
          "StoreID": RootBloc.store?.id,
          "Name": name,
        },
      ),
    ).map((event) => ResAccessGroupModel.fromJson(event.data));
  }

  Stream<ResDefaultModel> undoAccess(String id, ReqCrudOperationModel model) {
    return Stream.fromFuture(
      ApiManager().dio()!.patch(
        "${ApiConstants.getQuickAccess}/$id",
        data: [model.toJson()],
      ),
    ).map((event) => ResDefaultModel.fromJson(event.data));
  }

  ///Search Item api's
  Stream<ResItemDepartmentModel> getDepartment() {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.itemDepartment,
        queryParameters: {
          "IncludeInactive": false,
          "PageSize": 10000,
          "PageNumber": 1,
          "Usage": 0,
          "StoreID": RootBloc.store?.id,
        },
      ),
    ).map((event) {
      return ResItemDepartmentModel.fromJson(event.data);
    });
  }

  Stream<ResItemCategoryModel> getCategory() {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.itemCategory,
        queryParameters: {
          "IncludeInactive": false,
          "PageSize": 10000,
          "PageNumber": 1,
          "Usage": 0,
          "StoreID": RootBloc.store?.id,
        },
      ),
    ).map((event) => ResItemCategoryModel.fromJson(event.data));
  }

  Stream<ResSubCategoryModel> getSubCategory() {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.itemSubcategoryCollection,
        queryParameters: {
          "IncludeInactive": false,
          "PageSize": 10000,
          "PageNumber": 1,
          "Usage": 0,
          "StoreID:": RootBloc.store?.id,
        },
      ),
    ).map((event) {
      return ResSubCategoryModel.fromJson(event.data);
    });
  }

  Future<ResStoreItemModel> getStoreItems(
    String? itemName,
    String? deptId,
    String? catId,
    String? subCatId,
  ) async {
    var res = await ApiManager().dio()!.get(
      ApiConstants.storeItemApi,
      queryParameters: {
        "Usage": 2,
        "IncludeInactive": false,
        "StoreID": RootBloc.store?.id,
        "SortColumn": "UpdatedOn Desc",
        "PageNumber": 1,
        "PageSize": 10000,
        "Name": itemName ?? "",
        "ItemDeptID": deptId ?? Flavors.getGuid()!,
        "CategoryID": catId ?? Flavors.getGuid()!,
        "SubCategoryID": subCatId ?? Flavors.getGuid()!,
      },
    );
    return ResStoreItemModel.fromJson(res.data);
  }

  Stream<ResDefaultModel> addQuickAccessGroup(ReqQuickAccessGroupModel model) {
    return Stream.fromFuture(
      ApiManager().dio()!.post(ApiConstants.getQuickAccess, data: model.toJson()),
    ).map((event) => ResDefaultModel.fromJson(event.data));
  }

  Stream<ResAccessModel> getQuickAccess(String id) {
    return Stream.fromFuture(ApiManager().dio()!.get("${ApiConstants.getQuickAccess}/$id"))
        .map((event) => ResAccessModel.fromJson(event.data));
  }

  Stream<ResDefaultModel> updateQuickAccessGroup(String id, ReqQuickAccessGroupModel model) {
    return Stream.fromFuture(
      ApiManager().dio()!.put("${ApiConstants.getQuickAccess}/$id", data: model.toJson()),
    ).map((event) => ResDefaultModel.fromJson(event.data));
  }
}

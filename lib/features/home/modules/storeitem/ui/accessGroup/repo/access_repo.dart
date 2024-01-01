import 'package:ptecpos_mobile/core/utils/res_default_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_category_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_department_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_storeitem_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_sub_category_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/accessGroup/datasource/access_datasource.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/accessGroup/model/req_access_group_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/accessGroup/model/res_access_group_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/accessGroup/model/res_access_model.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/model/req_delete_trigger_model.dart';

class AccessRepo {
  final AccessDatasource _accessDatasource = AccessDatasource();

  Stream<ResAccessGroupModel> getAccessGroup(int pageSize, int pageNumber) {
    return _accessDatasource.getAccessGroup(pageSize, pageNumber);
  }

  Stream<ResAccessGroupModel> getFilteredAccessGroup({
    required int pageSize,
    required int pageNumber,
    bool? inActive,
    String? name,
  }) {
    return _accessDatasource.getFilteredAccessGroup(
      pageSize: pageSize,
      pageNumber: pageNumber,
      name: name,
      inActive: inActive,
    );
  }

  Stream<ResDefaultModel> undoAccess(String id, ReqCrudOperationModel model) {
    return _accessDatasource.undoAccess(id, model);
  }

  Stream<ResItemDepartmentModel> getDepartment() {
    return _accessDatasource.getDepartment();
  }

  Stream<ResItemCategoryModel> getCategory() {
    return _accessDatasource.getCategory();
  }

  Stream<ResSubCategoryModel> getSubCategory() {
    return _accessDatasource.getSubCategory();
  }

  Future<ResStoreItemModel> getStoreItems(
    String? itemName,
    String? deptId,
    String? catId,
    String? subCatId,
  ) async {
    return _accessDatasource.getStoreItems(itemName, deptId, catId, subCatId);
  }

  Stream<ResDefaultModel> addQuickAccessGroup(ReqQuickAccessGroupModel model) {
    return _accessDatasource.addQuickAccessGroup(model);
  }

  Stream<ResAccessModel> getQuickAccess(String id) {
    return _accessDatasource.getQuickAccess(id);
  }

  Stream<ResDefaultModel> updateQuickAccessGroup(String id, ReqQuickAccessGroupModel model) {
    return _accessDatasource.updateQuickAccessGroup(id, model);
  }
}

import 'package:ptecpos_mobile/core/utils/res_default_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_storeitem_model.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/datasource/tpr_datasource.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/model/req_delete_trigger_model.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/model/req_trigger_model.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/model/req_trigger_update_model.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/model/res_trigger_model.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/model/res_trigger_update_model.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/model/res_triggerpost_model.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/model/res_trptriggers_model.dart';

class TprRepo {
  final TprDatasource _tprDatasource = TprDatasource();

  Stream<ResTriggerModel> getTriggers(int pageSize, int pageNumber) {
    return _tprDatasource.getTriggers(pageSize, pageNumber);
  }

  Stream<ResTriggerModel> getFilterTriggers({
    required int pageSize,
    required int pageNumber,
    String? startDate,
    String? endDate,
    int? type,
  }) {
    return _tprDatasource.getFilterTriggers(
      pageSize: pageSize,
      pageNumber: pageNumber,
      type: type,
      endDate: endDate,
      startDate: startDate,
    );
  }

  Stream<ResStoreItemModel> getStoreItem() {
    return _tprDatasource.getStoreItem();
  }

  Stream<ResTrpTriggersModel> getTriggerPackage({required String storeItemId}) {
    return _tprDatasource.getTriggerPackage(storeItemId);
  }

  Stream<ResTriggerModel> getPackageTrigger({required String storeItemId, String? packageId}) {
    return _tprDatasource.getPackageTrigger(storeItemId: storeItemId, packageId: packageId);
  }

  Stream<ResTriggerPostModel> postTrigger(ReqTriggerModel model) {
    return _tprDatasource.postTrigger(model);
  }

  Stream<ResDefaultModel> updateTrigger(ReqTriggerUpdateModel model, String id) {
    return _tprDatasource.updateTrigger(model, id);
  }

  Stream<ResTriggerUpdateModel> getTrigger(String id) {
    return _tprDatasource.getTrigger(id);
  }

  Stream<ResDefaultModel> deleteTrigger(String id, ReqCrudOperationModel model) {
    return _tprDatasource.deleteTrigger(id, model);
  }
}

import 'package:ptecpos_mobile/core/domain/datasource/api_manager.dart';
import 'package:ptecpos_mobile/core/domain/model/response_model.dart';
import 'package:ptecpos_mobile/core/utils/api_constants.dart';
import 'package:ptecpos_mobile/features/store/data/model/res_storeitems_model.dart';

class StoreDataSource {
  Stream<StoreItemModel> getStoreItems(String pageNumber, String pageSize, String name) {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.getStoreApi,
        queryParameters: {
          "PageSize": pageSize,
          "PageNumber": pageNumber,
          "Name": name,
          "Usage":2,
        },
      ),
    ).map((event) {
      ResponseModel responseModel = ResponseModel.fromJson(event.data);
      return StoreItemModel.fromJson(responseModel.data);
    });
  }
}

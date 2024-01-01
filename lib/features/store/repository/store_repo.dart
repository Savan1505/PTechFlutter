import 'package:ptecpos_mobile/features/store/data/model/res_storeitems_model.dart';
import 'package:ptecpos_mobile/features/store/datasource/store_datasource.dart';

class StoreRepo {
  StoreDataSource storeDataSource = StoreDataSource();

  Stream<StoreItemModel> getStoreItemListApi({
    required int pageNumber,
    required int pageSize,
    String name = "",
  }) {
    return storeDataSource.getStoreItems(pageNumber.toString(), pageSize.toString(), name);
  }
}

import 'package:ptecpos_mobile/core/domain/datasource/api_manager.dart';
import 'package:ptecpos_mobile/core/root/root_bloc.dart';
import 'package:ptecpos_mobile/core/utils/api_constants.dart';
import 'package:ptecpos_mobile/core/utils/flavors.dart';
import 'package:ptecpos_mobile/core/utils/res_default_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/req_item_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_dept_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_age_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_category_collection.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_category_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_department_collection_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_department_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_package_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_regions_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_size_collection_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_sku_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_suppliers_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_type_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_itempack_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_scandata_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_storeitem_collectiontype_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_storeitem_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_sub_category_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_taxslab_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/abv/model/res_item_abv_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/category/model/req_item_category_dept_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/category/model/req_item_sub_category_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/category/model/res_item_category_dept_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/category/model/res_item_category_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/department/model/req_item_dept_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/department/model/req_item_tax_slab_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/department/model/res_dept_taxslab_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/department/model/res_item_tax_slab_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/flavour/model/res_item_flavour_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/package/model/res_item_pack_upc_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/regions/model/req_item_regions_model.dart';

class StoreItemDatasource {
  Stream<ResStoreItemModel> getStoreItems(String? itemName, int? pageNumber) {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.storeItemApi,
        queryParameters: {
          "Usage": 1,
          "StoreID": RootBloc.store?.id,
          "SortColumn": "UpdatedOn Desc",
          "PageNumber": pageNumber ?? 1,
          "PageSize": 30,
          "Name": itemName ?? "",
        },
      ),
    ).map((event) {
      return ResStoreItemModel.fromJson(event.data);
    });
  }

  /// ------------ Filter apis -----------------
  Stream<ResStoreItemTypeCollectionModel> getItemCollection() {
    return Stream.fromFuture(ApiManager().dio()!.get(ApiConstants.storeItemTypesCollection))
        .map((event) {
      return ResStoreItemTypeCollectionModel.fromJson(event.data);
    });
  }

  Stream<ResItemSizeCollectionModel> getItemSizeCollection() {
    return Stream.fromFuture(
      ApiManager().dio()!.get(ApiConstants.storeItemSizeCollection),
    ).map((event) {
      return ResItemSizeCollectionModel.fromJson(event.data);
    });
  }

  Stream<ResItemPackModel> getItemPack() {
    return Stream.fromFuture(
      ApiManager().dio()!.get(ApiConstants.itemPack),
    ).map((event) {
      return ResItemPackModel.fromJson(event.data);
    });
  }

  Stream<ResScanDataModel> getScanData() {
    return Stream.fromFuture(
      ApiManager().dio()!.get(ApiConstants.scanData),
    ).map((event) {
      return ResScanDataModel.fromJson(event.data);
    });
  }

  Stream<ResItemDepartmentCollectionModel> getDepartmentCollection() {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.itemDepartmentCollection,
        queryParameters: {
          "IncludeInactive": false,
          "PageSize": 10000,
          "PageNumber": 1,
          "Usage": 1,
          "StoreID": RootBloc.store?.id,
        },
      ),
    ).map((event) {
      return ResItemDepartmentCollectionModel.fromJson(event.data);
    });
  }

  Stream<ResDeptModel> getTaxDepartmentCollection(String deptId) {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
            "${ApiConstants.itemDepartmentCollection}/$deptId",
          ),
    ).map((event) {
      return ResDeptModel.fromJson(event.data);
    });
  }

  Stream<ResTaxSlabModel> getTaxSlab() {
    return Stream.fromFuture(ApiManager().dio()!.get(ApiConstants.taxSlabs)).map((event) {
      return ResTaxSlabModel.fromJson(event.data);
    });
  }

  Stream<ResItemCategoryCollectionModel> getItemCategory(String? deptId) {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.itemCategoryCollection,
        queryParameters: {
          "IncludeInactive": false,
          "PageSize": 10000,
          "PageNumber": 1,
          "Usage": 0,
          "StoreID": RootBloc.store?.id,
          "DeptID": deptId,
        },
      ),
    ).map((event) {
      return ResItemCategoryCollectionModel.fromJson(event.data);
    });
  }

  Stream<ResSubCategoryModel> getSubCategory(String categoryId) {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.itemSubcategoryCollection,
        queryParameters: {
          "IncludeInactive": false,
          "PageSize": 10,
          "PageNumber": 1,
          "Usage": 0,
          "CategoryID": categoryId,
        },
      ),
    ).map((event) {
      return ResSubCategoryModel.fromJson(event.data);
    });
  }

  Stream<ResStoreItemModel> getStoreFilteredItems({
    String? itemName,
    String? itemTypeId,
    String? itemDeptId,
    String? categoryId,
    String? subCategoryId,
    String? distributorId,
    String? itemTaxId,
    String? scanDataId,
    required int pageNumber,
    required int pageSize,
    int taxId = 0,
    bool isActiveFilter = false,
    bool isNonRevenueFilter = false,
    bool isNonDiscountFilter = false,
    bool isAllowFoodFilter = false,
    bool isNonStockItemFilter = false,
  }) {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.storeItemApi,
        queryParameters: {
          "Usage": 1,
          "StoreID": RootBloc.store?.id,
          "SortColumn": "UpdatedOn Desc",
          "PageNumber": pageNumber,
          "PageSize": pageSize,
          "Name": itemName ?? "",
          "ItemTypeID": itemTypeId ?? Flavors.getGuid(),
          "ItemDeptID": itemDeptId ?? Flavors.getGuid(),
          "CategoryID": categoryId ?? Flavors.getGuid(),
          "SubCategoryID": subCategoryId ?? Flavors.getGuid(),
          "DistributorID": distributorId ?? Flavors.getGuid(),
          "ItemTaxID": itemTaxId ?? Flavors.getGuid(),
          "ScanDataID": scanDataId ?? Flavors.getGuid(),
          "Tax": taxId,
          "InActive": isActiveFilter,
          "NonRevenue": isNonRevenueFilter,
          "NonDiscountable": isNonDiscountFilter,
          "AllowFoodStamp": isAllowFoodFilter,
          "NonStockItem": isNonStockItemFilter,
        },
      ),
    ).map((event) {
      return ResStoreItemModel.fromJson(event.data);
    });
  }

  ///----------------------------------------------

  /// Add item apis ----------------
  Stream<ResItemTypeModel> getItemType() {
    return Stream.fromFuture(ApiManager().dio()!.get(ApiConstants.itemType)).map((event) {
      return ResItemTypeModel.fromJson(event.data);
    });
  }

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

  Stream<ResDefaultModel> postDepartment(ReqItemDeptModel reqItemDeptModel) {
    return Stream.fromFuture(
      ApiManager().dio()!.post(ApiConstants.itemDepartment, data: reqItemDeptModel.toJson()),
    ).map((event) => ResDefaultModel.fromJson(event.data));
  }

  Stream<ResDeptTaxSlabModel> getDeptItemTax() {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.itemTax,
        queryParameters: {
          "IncludeInactive": false,
          "PageSize": 10000,
          "PageNumber": 1,
          "StoreID": RootBloc.store?.id,
        },
      ),
    ).map((event) {
      return ResDeptTaxSlabModel.fromJson(event.data);
    });
  }

  Stream<ResItemCategoryModel> getItemTypeCategory(String? deptId) {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.itemCategory,
        queryParameters: {
          "IncludeInactive": false,
          "PageSize": 10000,
          "PageNumber": 1,
          "Usage": 0,
          "StoreID": RootBloc.store?.id,
          "DeptID": deptId,
        },
      ),
    ).map((event) => ResItemCategoryModel.fromJson(event.data));
  }

  Stream<ResItemCategoryDeptModel> postItemCategoryDepartment(
    ReqItemCategoryDeptModel reqItemCategoryDeptModel,
  ) {
    return Stream.fromFuture(
      ApiManager()
          .dio()!
          .post(ApiConstants.itemCategoryCollection, data: reqItemCategoryDeptModel.toJson()),
    ).map((event) => ResItemCategoryDeptModel.fromJson(event.data));
  }

  Stream<ResItemSubCategoryModel> postItemSubCategory(ReqItemSubCategoryModel reqItemSubCategoryModel) {
    return Stream.fromFuture(
      ApiManager()
          .dio()!
          .post(ApiConstants.itemSubcategoryCollection, data: reqItemSubCategoryModel.toJson()),
    ).map((event) => ResItemSubCategoryModel.fromJson(event.data));
  }

  Stream<ResItemSkuModel> getItemSku() {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.skuGenerate,
        queryParameters: {"StoreID": RootBloc.store?.id, "Records": 1},
      ),
    ).map((event) => ResItemSkuModel.fromJson(event.data));
  }

  Stream<ResDefaultModel> checkUpc(String value) {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.itemPackUpc,
        queryParameters: {"Value": value, "ValueType": 1, "StoreID": RootBloc.store?.id},
      ),
    ).map((event) => ResDefaultModel.fromJson(event.data));
  }

  Stream<ResItemTaxLabModel> postTaxSlab(ReqItemTaxLabModel reqItemTaxLabModel) {
    return Stream.fromFuture(
      ApiManager().dio()!.post(ApiConstants.itemTax, data: reqItemTaxLabModel.toJson()),
    ).map((event) => ResItemTaxLabModel.fromJson(event.data));
  }

  Stream<ResItemRegionsModel> getItemRegions() {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.itemRegions,
        queryParameters: {
          "IncludeInactive": false,
          "PageSize": 10000,
          "PageNumber": 1,
          "Usage": 0,
          "StoreID": RootBloc.store?.id,
        },
      ),
    ).map((event) => ResItemRegionsModel.fromJson(event.data));
  }

  Stream<ResDefaultModel> postRegions(ReqItemRegionsModel regionsModel) {
    return Stream.fromFuture(
      ApiManager().dio()!.post(
            ApiConstants.itemRegions,
            data: regionsModel.toJson(),
          ),
    ).map((event) => ResDefaultModel.fromJson(event.data));
  }

  Stream<ResItemAbvModel> getItemAbv() {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.itemAbv,
        queryParameters: {
          "IncludeInactive": false,
          "PageSize": 10000,
          "PageNumber": 1,
          "Usage": 0,
          "StoreID": RootBloc.store?.id,
        },
      ),
    ).map((event) {
      return ResItemAbvModel.fromJson(event.data);
    });
  }

  Stream<ResDefaultModel> postAbv(ReqItemRegionsModel regionsModel) {
    return Stream.fromFuture(
      ApiManager().dio()!.post(
            ApiConstants.itemAbv,
            data: regionsModel.toJson(),
          ),
    ).map((event) => ResDefaultModel.fromJson(event.data));
  }

  Stream<ResItemFlavourModel> getFlavour() {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.itemFlavour,
        queryParameters: {
          "IncludeInactive": false,
          "PageSize": 10000,
          "PageNumber": 1,
          "Usage": 0,
          "StoreID": RootBloc.store?.id,
        },
      ),
    ).map((event) => ResItemFlavourModel.fromJson(event.data));
  }

  Stream<ResItemAgeModel> getItemAge() {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.itemAge,
        queryParameters: {
          "IncludeInactive": false,
          "PageSize": 10000,
          "PageNumber": 1,
          "Usage": 0,
          "StoreID": RootBloc.store?.id,
        },
      ),
    ).map((event) => ResItemAgeModel.fromJson(event.data));
  }

  Stream<ResDefaultModel> postFlavour(ReqItemRegionsModel regionsModel) {
    return Stream.fromFuture(
      ApiManager().dio()!.post(
            ApiConstants.itemFlavour,
            data: regionsModel.toJson(),
          ),
    ).map((event) => ResDefaultModel.fromJson(event.data));
  }

  Stream<ResItemFlavourModel> getFamily() {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.itemFamily,
        queryParameters: {
          "IncludeInactive": false,
          "PageSize": 10000,
          "PageNumber": 1,
          "Usage": 0,
          "StoreID": RootBloc.store?.id,
        },
      ),
    ).map((event) => ResItemFlavourModel.fromJson(event.data));
  }

  Stream<ResDefaultModel> postFamily(ReqItemRegionsModel regionsModel) {
    return Stream.fromFuture(
      ApiManager().dio()!.post(
            ApiConstants.itemFamily,
            data: regionsModel.toJson(),
          ),
    ).map((event) => ResDefaultModel.fromJson(event.data));
  }

  Stream<ResItemFlavourModel> getVintage() {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.itemVintage,
        queryParameters: {
          "IncludeInactive": false,
          "PageSize": 10000,
          "PageNumber": 1,
          "Usage": 0,
          "StoreID": RootBloc.store?.id,
        },
      ),
    ).map((event) => ResItemFlavourModel.fromJson(event.data));
  }

  Stream<ResDefaultModel> postVintage(ReqItemRegionsModel regionsModel) {
    return Stream.fromFuture(
      ApiManager().dio()!.post(
            ApiConstants.itemVintage,
            data: regionsModel.toJson(),
          ),
    ).map((event) => ResDefaultModel.fromJson(event.data));
  }

  Stream<ResItemSuppliersModel> getItemSuppliers() {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.itemsSuppliers,
        queryParameters: {
          "IncludeInactive": false,
          "PageSize": 10000,
          "PageNumber": 1,
          "Usage": 0,
          "StoreID": RootBloc.store?.id,
        },
      ),
    ).map((event) => ResItemSuppliersModel.fromJson(event.data));
  }

  Stream<ResItemSizeCollectionModel> getItemPackageSizeCollection() {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.storeItemSizeCollection,
        queryParameters: {
          "IncludeInactive": false,
          "PageSize": 10000,
          "PageNumber": 1,
          "Usage": 0,
          "StoreID": RootBloc.store?.id,
        },
      ),
    ).map((event) {
      return ResItemSizeCollectionModel.fromJson(event.data);
    });
  }

  Stream<ResDefaultModel> addPackUpc(String value) {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.itemPackUpc,
        queryParameters: {"Value": value, "ValueType": 2, "StoreID": RootBloc.store?.id},
      ),
    ).map((event) => ResDefaultModel.fromJson(event.data));
  }

  Stream<ResItemPackUpcModel> generatePackUpc() {
    return Stream.fromFuture(
      ApiManager().dio()!.get(
        ApiConstants.itemPackUpcGenerate,
        queryParameters: {"StoreID": RootBloc.store?.id, "Records": 1},
      ),
    ).map((event) => ResItemPackUpcModel.fromJson(event.data));
  }

  Stream<ResItemPackageModel> postItemData(ReqItemPackageModel reqItemPackageModel) {
    return Stream.fromFuture(
      ApiManager().dio()!.post(ApiConstants.storeItemApi, data: reqItemPackageModel.toJson()),
    ).map((event) => ResItemPackageModel.fromJson(event.data));
  }
}

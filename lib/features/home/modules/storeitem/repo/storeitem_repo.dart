import 'package:ptecpos_mobile/core/utils/res_default_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/datasource/store_item_datasource.dart';
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

class StoreItemRepo {
  final StoreItemDatasource storeItemDatasource = StoreItemDatasource();

  Stream<ResStoreItemModel> getStoreItem({String? itemName, int? pageNumber}) {
    return storeItemDatasource.getStoreItems(itemName, pageNumber);
  }

  ///-------------- Filter repos ----------------
  Stream<ResStoreItemTypeCollectionModel> getItemCollection() {
    return storeItemDatasource.getItemCollection();
  }

  Stream<ResItemSizeCollectionModel> getItemSizeCollection() {
    return storeItemDatasource.getItemSizeCollection();
  }

  Stream<ResItemPackModel> getItemPack() {
    return storeItemDatasource.getItemPack();
  }

  Stream<ResScanDataModel> getScanData() {
    return storeItemDatasource.getScanData();
  }

  Stream<ResItemDepartmentCollectionModel> getDepartmentCollection() {
    return storeItemDatasource.getDepartmentCollection();
  }

  Stream<ResDeptModel> getTaxDepartmentCollection(String deptId) {
    return storeItemDatasource.getTaxDepartmentCollection(deptId);
  }

  Stream<ResTaxSlabModel> getTaxSlab() {
    return storeItemDatasource.getTaxSlab();
  }

  Stream<ResItemCategoryCollectionModel> getItemCategory(String? deptId) {
    return storeItemDatasource.getItemCategory(deptId);
  }

  Stream<ResSubCategoryModel> getSubcategory(String categoryID) {
    return storeItemDatasource.getSubCategory(categoryID);
  }

  Stream<ResStoreItemModel> getStoreFilteredItems({
    required int pageNumber,
    required int pageSize,
    String? itemName,
    String? itemTypeId,
    String? itemDeptId,
    String? categoryId,
    String? subCategoryId,
    String? distributorId,
    String? itemTaxId,
    String? scanDataId,
    int taxId = 0,
    bool isActiveFilter = false,
    bool isNonRevenueFilter = false,
    bool isNonDiscountFilter = false,
    bool isAllowFoodFilter = false,
    bool isNonStockItemFilter = false,
  }) {
    return storeItemDatasource.getStoreFilteredItems(
      pageNumber: pageNumber,
      pageSize: pageSize,
      categoryId: categoryId,
      distributorId: distributorId,
      isActiveFilter: isActiveFilter,
      isAllowFoodFilter: isAllowFoodFilter,
      isNonDiscountFilter: isNonDiscountFilter,
      isNonRevenueFilter: isNonRevenueFilter,
      isNonStockItemFilter: isNonStockItemFilter,
      itemDeptId: itemDeptId,
      itemName: itemName,
      itemTaxId: itemTaxId,
      itemTypeId: itemTypeId,
      scanDataId: scanDataId,
      subCategoryId: subCategoryId,
      taxId: taxId,
    );
  }

  ///-----------------------------

  ///Add item repos ----------------------
  Stream<ResItemTypeModel> getItemType() {
    return storeItemDatasource.getItemType();
  }

  Stream<ResItemDepartmentModel> getItemDepartment() {
    return storeItemDatasource.getDepartment();
  }

  Stream<ResDefaultModel> postDepartment(ReqItemDeptModel reqItemDeptModel) {
    return storeItemDatasource.postDepartment(reqItemDeptModel);
  }

  Stream<ResDeptTaxSlabModel> getDeptItemTax() {
    return storeItemDatasource.getDeptItemTax();
  }

  Stream<ResItemCategoryModel> getItemTypeCategory({String? deptId}) {
    return storeItemDatasource.getItemTypeCategory(deptId);
  }

  Stream<ResItemCategoryDeptModel> postItemCategoryDepartment(
    ReqItemCategoryDeptModel reqItemCategoryDeptModel,
  ) {
    return storeItemDatasource.postItemCategoryDepartment(reqItemCategoryDeptModel);
  }

  Stream<ResItemSubCategoryModel> postItemSubCategory(ReqItemSubCategoryModel reqItemSubCategoryModel) {
    return storeItemDatasource.postItemSubCategory(reqItemSubCategoryModel);
  }

  Stream<ResItemSkuModel> getItemSku() {
    return storeItemDatasource.getItemSku();
  }

  Stream<ResDefaultModel> checkUpc(String value) {
    return storeItemDatasource.checkUpc(value);
  }

  Stream<ResItemTaxLabModel> postTaxSlab(ReqItemTaxLabModel reqItemTaxLabModel) {
    return storeItemDatasource.postTaxSlab(reqItemTaxLabModel);
  }

  Stream<ResItemRegionsModel> getItemRegions() {
    return storeItemDatasource.getItemRegions();
  }

  Stream<ResDefaultModel> postRegions(ReqItemRegionsModel regionsModel) {
    return storeItemDatasource.postRegions(regionsModel);
  }

  Stream<ResItemAbvModel> getItemAbv() {
    return storeItemDatasource.getItemAbv();
  }

  Stream<ResDefaultModel> postAbv(ReqItemRegionsModel regionsModel) {
    return storeItemDatasource.postAbv(regionsModel);
  }

  Stream<ResItemFlavourModel> getFlavour() {
    return storeItemDatasource.getFlavour();
  }

  Stream<ResItemAgeModel> getItemAge() {
    return storeItemDatasource.getItemAge();
  }

  Stream<ResDefaultModel> postFlavour(ReqItemRegionsModel regionsModel) {
    return storeItemDatasource.postFlavour(regionsModel);
  }

  Stream<ResItemFlavourModel> getFamily() {
    return storeItemDatasource.getFamily();
  }

  Stream<ResDefaultModel> postFamily(ReqItemRegionsModel regionsModel) {
    return storeItemDatasource.postFamily(regionsModel);
  }

  Stream<ResItemFlavourModel> getVintage() {
    return storeItemDatasource.getVintage();
  }

  Stream<ResDefaultModel> postVintage(ReqItemRegionsModel regionsModel) {
    return storeItemDatasource.postVintage(regionsModel);
  }

  Stream<ResItemSuppliersModel> getItemSuppliers() {
    return storeItemDatasource.getItemSuppliers();
  }

  Stream<ResItemSizeCollectionModel> getItemPackageSizeCollection() {
    return storeItemDatasource.getItemPackageSizeCollection();
  }

  Stream<ResDefaultModel> addPackUpc(String value) {
    return storeItemDatasource.addPackUpc(value);
  }

  Stream<ResItemPackUpcModel> generatePackUpc() {
    return storeItemDatasource.generatePackUpc();
  }

  Stream<ResItemPackageModel> postItemData(ReqItemPackageModel reqItemPackageModel) {
    return storeItemDatasource.postItemData(reqItemPackageModel);
  }
}

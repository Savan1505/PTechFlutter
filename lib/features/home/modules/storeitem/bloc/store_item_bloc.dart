import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:ptecpos_mobile/core/base/base_bloc.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/core/widget/debouncer.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/req_tax_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_distrubutor_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_category_collection.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_department_collection_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_size_collection_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_itempack_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_scandata_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_storeitem_collectiontype_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_storeitem_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_sub_category_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_taxslab_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/repo/storeitem_repo.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/state/store_item_state.dart';
import 'package:rxdart/rxdart.dart';

class StoreItemBloc extends BaseBloc {
  BehaviorSubject<List<int>> selectedItems = BehaviorSubject<List<int>>.seeded([]);
  BehaviorSubject<bool> isSearchEnabled = BehaviorSubject<bool>.seeded(false);
  TextEditingController searchItemController = TextEditingController();
  BehaviorSubject<bool> loadingStoreItem = BehaviorSubject<bool>.seeded(false);
  bool isFilterCalled = false;
  ScrollController scrollController = ScrollController();

  final StoreItemRepo _storeItemRepo = StoreItemRepo();

  BehaviorSubject<StoreItemState> storeItemState = BehaviorSubject<StoreItemState>();
  BehaviorSubject<StoreItemState> searchedStoreItemState =
      BehaviorSubject<StoreItemState>.seeded(StoreItemState.completed(true));
  BehaviorSubject<StoreItemState> filterState = BehaviorSubject<StoreItemState>();
  late ResStoreItemModel resStoreItemModel;
  ReqTaxModel allTax = ReqTaxModel(label: "All".i18n, id: 0);
  ReqTaxModel taxableTax = ReqTaxModel(label: "Taxable".i18n, id: 1);
  ReqTaxModel nonTaxableTax = ReqTaxModel(label: "NonTaxable", id: 2);
  int pageNumber = 1;
  int pageSize = 30;
  final Debouncer debouncer = Debouncer(milliseconds: 400);

  ///Filter data
  late ResStoreItemTypeCollectionModel resStoreItemTypeCollectionModel;
  late ResItemSizeCollectionModel resItemSizeCollectionModel;
  late ResItemPackModel resItemPackModel;
  late ResScanDataModel resScanDataModel;
  late ResItemDepartmentCollectionModel resItemDepartmentCollectionModel;
  late ResTaxSlabModel resTaxSlabModel;
  late ResItemCategoryCollectionModel resItemCategoryCollectionModel;

  ResSubCategoryModel resSubCategoryModel = ResSubCategoryModel(
    data: SubcategoryData(
      list: [],
      count: 0,
    ),
  );
  BehaviorSubject<bool> isSubCategoryCalled = BehaviorSubject<bool>.seeded(false);

  TextEditingController companyController = TextEditingController();

  ///Filter selected data
  BehaviorSubject<DepartmentCollection?> departmentValue = BehaviorSubject<DepartmentCollection?>();
  BehaviorSubject<CategoryCollection?> categoryValue = BehaviorSubject<CategoryCollection?>();
  BehaviorSubject<ItemTypeCollection?> itemTypeValue = BehaviorSubject<ItemTypeCollection?>();
  BehaviorSubject<Subcategory?> subCategoryValue = BehaviorSubject<Subcategory?>();
  BehaviorSubject<TaxSlab?> taxSlabValue = BehaviorSubject<TaxSlab?>();
  BehaviorSubject<Scan?> scanDataValue = BehaviorSubject<Scan?>();
  BehaviorSubject<ReqTaxModel> taxValue = BehaviorSubject<ReqTaxModel>();
  Distributor? distributorCompanyData;
  List<BehaviorSubject<bool>> otherFilter = [
    BehaviorSubject<bool>.seeded(false),
    BehaviorSubject<bool>.seeded(false),
    BehaviorSubject<bool>.seeded(false),
    BehaviorSubject<bool>.seeded(false),
    BehaviorSubject<bool>.seeded(false),
    BehaviorSubject<bool>.seeded(false),
  ];

  BehaviorSubject<bool> companyFieldFocus = BehaviorSubject<bool>.seeded(false);
  List<ReqTaxModel> taxFilters = [];
  List<String> otherFilters = [
    "In-Active",
    "Non-Revenue",
    "Non-Discount Item",
    "Food Stamp",
    "Non Stock Item",
  ];

  ///---------Is applied clicked ----------------
  bool isAppliedClick = false;

  void getStoreItem() {
    pageNumber = 1;
    storeItemState.add(StoreItemState.loading());
    subscription.add(
      _storeItemRepo.getStoreItem().map((event) {
        if (!(event.error ?? true)) {
          resStoreItemModel = event;
          storeItemState.add(StoreItemState.completed(true));
        } else {
          storeItemState.add(StoreItemState.error(true));
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        storeItemState.add(StoreItemState.error(true));
        if (error is DioException) {
          var err = error;
          var res = ResStoreItemModel.fromJson(err.response?.data ?? {});
          if (!(res.error ?? true)) {
            AppUtil.showSnackBar(label: res.message ?? "Something went wrong".i18n);
          } else {
            if (err.error is SocketException) {
              var e = err.error as SocketException;
              AppUtil.showSnackBar(label: e.osError?.message ?? "Something went wrong".i18n);
            } else {
              AppUtil.showSnackBar(label: "Something went wrong".i18n);
            }
          }
        } else {
          AppUtil.showSnackBar(label: "Something went wrong".i18n);
        }
      }).listen((event) {}),
    );
  }

  void getFilterData() {
    if (!isAppliedClick) {
      resetValue();
    }

    filterState.add(StoreItemState.loading());
    subscription.add(
      ZipStream.zip7(
          _storeItemRepo.getItemCollection(),
          _storeItemRepo.getItemSizeCollection(),
          _storeItemRepo.getItemPack(),
          _storeItemRepo.getScanData(),
          _storeItemRepo.getDepartmentCollection(),
          _storeItemRepo.getTaxSlab(),
          _storeItemRepo.getItemCategory(""), (
        resStoreItemTypeCollectionModel,
        resItemSizeCollectionModel,
        resItemPackModel,
        resScanDataModel,
        resItemDepartmentCollectionModel,
        resTaxSlabModel,
        resItemCategoryCollectionModel,
      ) {
        if (!(resStoreItemTypeCollectionModel.error ?? true) &&
            !(resItemSizeCollectionModel.error ?? true) &&
            !(resItemPackModel.error ?? true) &&
            !(resScanDataModel.error ?? true) &&
            !(resItemDepartmentCollectionModel.error ?? true) &&
            !(resTaxSlabModel.error ?? true) &&
            !(resItemCategoryCollectionModel.error ?? true)) {
          this.resStoreItemTypeCollectionModel = resStoreItemTypeCollectionModel;
          this.resItemSizeCollectionModel = resItemSizeCollectionModel;
          this.resItemPackModel = resItemPackModel;
          this.resScanDataModel = resScanDataModel;
          this.resItemDepartmentCollectionModel = resItemDepartmentCollectionModel;
          this.resTaxSlabModel = resTaxSlabModel;
          this.resItemCategoryCollectionModel = resItemCategoryCollectionModel;
          filterState.add(StoreItemState.completed(true));
        } else {
          AppUtil.showSnackBar(
            label: resStoreItemTypeCollectionModel.message ??
                resItemSizeCollectionModel.message ??
                resItemPackModel.message ??
                resScanDataModel.message ??
                resItemDepartmentCollectionModel.message ??
                resTaxSlabModel.message ??
                resItemCategoryCollectionModel.message ??
                "Something went wrong".i18n,
          );
          filterState.add(StoreItemState.error(true));
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        filterState.add(StoreItemState.error(true));
        filterState.add(StoreItemState.error(true));
        if (error is DioException) {
          var err = error;
          var res = ResItemPackModel.fromJson(err.response?.data ?? {});
          if (!(res.error ?? true)) {
            AppUtil.showSnackBar(label: res.message ?? "Something went wrong".i18n);
          } else {
            if (err.error is SocketException) {
              var e = err.error as SocketException;
              AppUtil.showSnackBar(label: e.osError?.message ?? "Something went wrong".i18n);
            } else {
              AppUtil.showSnackBar(label: "Something went wrong".i18n);
            }
          }
        } else {
          AppUtil.showSnackBar(label: "Something went wrong".i18n);
        }
      }).listen((event) {}),
    );
  }

  void getSubcategory(String categoryID) {
    subscription.add(
      _storeItemRepo.getSubcategory(categoryID).map((event) {
        if (!(event.error ?? true)) {
          resSubCategoryModel = event;
          isSubCategoryCalled.add(true);
        } else {
          resSubCategoryModel = ResSubCategoryModel();
          AppUtil.showSnackBar(
            label: event.message ?? "Something went wrong while fetching sub category".i18n,
          );
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        AppUtil.showSnackBar(label: "Something went wrong while fetching sub category".i18n);
      }).listen((event) {}),
    );
  }

  void getCategory(String deptId) {
    subscription.add(
      _storeItemRepo.getItemCategory(deptId).map((event) {
        if (!(event.error ?? true)) {
          resItemCategoryCollectionModel = event;
          categoryValue.add(null);
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        AppUtil.showSnackBar(label: "Something went wrong".i18n);
      }).listen((event) {}),
    );
  }

  void resetValue() {
    departmentValue.add(null);
    categoryValue.add(null);
    itemTypeValue.add(null);
    taxSlabValue.add(null);
    scanDataValue.add(null);
    subCategoryValue.add(null);
    taxValue.add(allTax);
    taxFilters = [allTax, taxableTax, nonTaxableTax];
    companyController.clear();

    for (var element in otherFilter) {
      element.add(false);
    }
  }

  void getItemFilteredData() {
    pageNumber = 1;
    storeItemState.add(StoreItemState.loading());
    subscription.add(
      _storeItemRepo
          .getStoreFilteredItems(
        pageNumber: pageNumber,
        pageSize: pageSize,
        taxId: taxValue.value.id,
        subCategoryId: subCategoryValue.valueOrNull?.id,
        scanDataId: scanDataValue.valueOrNull?.id,
        itemTypeId: itemTypeValue.valueOrNull?.id,
        itemTaxId: taxSlabValue.valueOrNull?.id,
        itemDeptId: departmentValue.valueOrNull?.id,
        isNonStockItemFilter: otherFilter[4].valueOrNull ?? false,
        isNonRevenueFilter: otherFilter[1].valueOrNull ?? false,
        isNonDiscountFilter: otherFilter[2].valueOrNull ?? false,
        isAllowFoodFilter: otherFilter[3].valueOrNull ?? false,
        isActiveFilter: otherFilter[0].valueOrNull ?? false,
        distributorId: distributorCompanyData?.id,
        categoryId: categoryValue.valueOrNull?.id,
      )
          .map((event) {
        if (!(event.error ?? true)) {
          resStoreItemModel = event;
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
        }
        storeItemState.add(StoreItemState.completed(true));
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        AppUtil.showSnackBar(label: "Something went wrong".i18n);
      }).listen((event) {}),
    );
  }

  ///-------------Scroll data -----------------
  void scrollListener() {
    if (resStoreItemModel.data!.list!.length < resStoreItemModel.data!.count! &&
        !loadingStoreItem.value) {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        loadingStoreItem.add(true);
        ++pageNumber;

        getStoreItemPaginated();
      }
    }
  }

  void getStoreItemPaginated() {
    if (isAppliedClick) {
      getSearchedItemFilteredData(pageReset: false);
    } else {
      getSearchedStoreItem(pageReset: false);
    }
  }

  ///Searched filtered data -----------------
  void getSearchedItemFilteredData({bool pageReset = true}) {
    if (pageReset) {
      pageNumber = 1;
      searchedStoreItemState.add(StoreItemState.loading());
    }

    subscription.add(
      _storeItemRepo
          .getStoreFilteredItems(
        pageNumber: pageNumber,
        pageSize: pageSize,
        taxId: taxValue.value.id,
        subCategoryId: subCategoryValue.valueOrNull?.id,
        scanDataId: scanDataValue.valueOrNull?.id,
        itemTypeId: itemTypeValue.valueOrNull?.id,
        itemTaxId: taxSlabValue.valueOrNull?.id,
        itemName: searchItemController.text,
        itemDeptId: departmentValue.valueOrNull?.id,
        isNonStockItemFilter: otherFilter[4].valueOrNull ?? false,
        isNonRevenueFilter: otherFilter[1].valueOrNull ?? false,
        isNonDiscountFilter: otherFilter[2].valueOrNull ?? false,
        isAllowFoodFilter: otherFilter[3].valueOrNull ?? false,
        isActiveFilter: otherFilter[0].valueOrNull ?? false,
        distributorId: distributorCompanyData?.id,
        categoryId: categoryValue.valueOrNull?.id,
      )
          .map((event) {
        if (!(event.error ?? true)) {
          if (pageReset) {
            resStoreItemModel = event;
          } else {
            resStoreItemModel.data!.list!.addAll(event.data!.list!);
          }
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
        }
        if (pageReset) {
          searchedStoreItemState.add(StoreItemState.completed(true));
        } else {
          storeItemState.add(StoreItemState.completed(true));
        }
        loadingStoreItem.add(false);
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        loadingStoreItem.add(false);
      }).listen((event) {}),
    );
  }

  ///Searched item data -------------
  void getSearchedStoreItem({bool pageReset = true}) {
    if (pageReset) {
      pageNumber = 1;
      searchedStoreItemState.add(StoreItemState.loading());
    }

    subscription.add(
      _storeItemRepo
          .getStoreItem(itemName: searchItemController.text, pageNumber: pageNumber)
          .map((event) {
        if (!(event.error ?? true)) {
          if (pageReset) {
            resStoreItemModel = event;
          } else {
            resStoreItemModel.data!.list!.addAll(event.data!.list!);
          }
        }
        if (pageReset) {
          searchedStoreItemState.add(StoreItemState.completed(true));
        } else {
          storeItemState.add(StoreItemState.completed(true));
        }

        loadingStoreItem.add(false);
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        loadingStoreItem.add(false);
      }).listen((event) {}),
    );
  }
}

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ptecpos_mobile/core/base/base_bloc.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/root/root_bloc.dart';
import 'package:ptecpos_mobile/core/routes/app_router.dart';
import 'package:ptecpos_mobile/core/routes/tab_navigator.dart';
import 'package:ptecpos_mobile/core/utils/app_enum.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/core/utils/flavors.dart';
import 'package:ptecpos_mobile/core/utils/res_default_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/req_item_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_dept_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_age_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_category_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_country_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_department_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_regions_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_size_collection_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_sku_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_item_suppliers_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_scandata_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_storeitem_collectiontype_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/model/res_sub_category_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/repo/storeitem_repo.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/state/store_item_state.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/abv/model/res_item_abv_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/category/model/req_item_category_dept_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/category/model/req_item_sub_category_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/category/model/res_item_category_dept_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/department/model/req_item_dept_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/department/model/req_item_tax_slab_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/department/model/res_dept_taxslab_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/department/model/res_item_tax_slab_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/department/model/tax_slab_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/flavour/model/res_item_flavour_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/package/model/item_pack_upc_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/package/model/item_package_model.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/regions/model/req_item_regions_model.dart';
import 'package:rxdart/rxdart.dart';

class ItemBloc extends BaseBloc {
  ///V1 Page Variables
  //BehaviorSubject<bool> itemNameTap = BehaviorSubject<bool>.seeded(false);
  late BehaviorSubject<bool> itemNameTap;

  BehaviorSubject<bool> skuTap = BehaviorSubject<bool>.seeded(false);

  BehaviorSubject<XFile?> pickedImage = BehaviorSubject<XFile?>();
  final ImagePicker picker = ImagePicker();

  TextEditingController itemNameController = TextEditingController();
  TextEditingController skuController = TextEditingController();

  BehaviorSubject<bool> itemNameShowError = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> skuShowError = BehaviorSubject<bool>.seeded(false);
  String skuErrorMessage = 'Please Enter SKU'.i18n;

  BehaviorSubject<bool> rebuildPage1 = BehaviorSubject<bool>.seeded(false);

  bool isSkuGenerated = false;
  ResItemSkuModel? resItemSkuModel;

  final formKeyV1 = GlobalKey<FormState>();
  BehaviorSubject<StoreItemState> itemCategoryState = BehaviorSubject<StoreItemState>();
  BehaviorSubject<StoreItemState> itemSubCategoryState = BehaviorSubject<StoreItemState>();
  BehaviorSubject<StoreItemState> itemCategoryDepartmentState = BehaviorSubject<StoreItemState>();
  BehaviorSubject<StoreItemState> itemSubmoduleCategoryState = BehaviorSubject<StoreItemState>();

  late ResItemCategoryModel resItemCategoryModel;
  late ResSubCategoryModel resSubCategoryModel;
  late ResItemDepartmentModel resItemDepartmentCategoryModel;
  late ResItemCategoryModel resItemSubModuleCategoryModel;
  late ResStoreItemTypeCollectionModel resStoreItemTypeCollectionModel;
  late ResItemSuppliersModel resItemSuppliersModel;
  late ResItemAgeModel resItemAgeModel;
  late ResScanDataModel resScanDataModel;

  BehaviorSubject<ItemCategory?> itemCategoryValue = BehaviorSubject<ItemCategory?>();
  BehaviorSubject<ItemDepartment?> itemCategoryDepartment = BehaviorSubject<ItemDepartment?>();
  BehaviorSubject<Subcategory?> itemSubCategoryValue = BehaviorSubject<Subcategory?>();
  BehaviorSubject<ItemCategory?> itemSubModuleCategoryValue = BehaviorSubject<ItemCategory?>();
  BehaviorSubject<ItemTypeCollection?> itemTypeValue = BehaviorSubject<ItemTypeCollection?>();

  List<BehaviorSubject<TaxSlabModel>> taxSlabs = [];

  ///V2 Page Variables
  BehaviorSubject<bool> countryTap = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> itemShelfLifeTap = BehaviorSubject<bool>.seeded(false);

  BehaviorSubject<bool> rebuildPage2 = BehaviorSubject<bool>.seeded(false);

  TextEditingController countryController = TextEditingController();
  TextEditingController itemShelfLifeController = TextEditingController();
  ItemCountry? itemCountrySelected;

  BehaviorSubject<StoreItemState> itemRegionsState = BehaviorSubject<StoreItemState>();
  BehaviorSubject<StoreItemState> itemAbvState = BehaviorSubject<StoreItemState>();
  BehaviorSubject<StoreItemState> itemFlavourState = BehaviorSubject<StoreItemState>();
  BehaviorSubject<StoreItemState> itemFamilyState = BehaviorSubject<StoreItemState>();

  late ResItemRegionsModel resItemRegionsModel;
  late ResItemAbvModel resItemAbvModel;
  late ResItemFlavourModel resItemFlavourModel;
  late ResItemFlavourModel resItemFamilyModel;

  BehaviorSubject<ItemRegions?> itemRegionsValue = BehaviorSubject<ItemRegions?>();
  BehaviorSubject<ItemAbv?> itemAbvValue = BehaviorSubject<ItemAbv?>();
  BehaviorSubject<ItemFlavour?> itemFlavourValue = BehaviorSubject<ItemFlavour?>();
  BehaviorSubject<ItemFlavour?> itemFamilyValue = BehaviorSubject<ItemFlavour?>();

  List<String> uomValues = ["Unit", "Volume", "Weight"];
  BehaviorSubject<String> uomValue = BehaviorSubject<String>.seeded("Unit");

  List<String> ageValues = ["+18", "+21"];
  BehaviorSubject<ItemAge?> ageValue = BehaviorSubject<ItemAge?>();

  ///V3 Page Variables

  BehaviorSubject<bool> rebuildPage3 = BehaviorSubject<bool>.seeded(false);

  BehaviorSubject<StoreItemState> itemVintageState = BehaviorSubject<StoreItemState>();
  BehaviorSubject<ItemSuppliers?> itemSupplierValue = BehaviorSubject<ItemSuppliers?>();

  BehaviorSubject<bool> scanDataAllowed = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<Scan?> itemScanValue = BehaviorSubject<Scan?>();

  late ResItemFlavourModel resItemVintageModel;

  BehaviorSubject<ItemFlavour?> itemVintageValue = BehaviorSubject<ItemFlavour?>();
  BehaviorSubject<bool> taxSlabAllowed = BehaviorSubject<bool>.seeded(false);

  List<BehaviorSubject<TaxSlabModel>> itemTaxSlabs = [];

  bool isTaxSavedBtn = false;

  List<String> triggersValues = [
    "Open Price",
    "Non Revenue",
    "Non Return",
    "EBT",
    "WIC",
    "DELI PLU",
    "Open Qty",
    "InActive",
    "Non-Discount",
    "No Transfer",
    "Non-Credit Card",
    "Non Stockable",
  ];
  List<BehaviorSubject<bool>> triggersValue = [
    BehaviorSubject<bool>.seeded(false),
    BehaviorSubject<bool>.seeded(false),
    BehaviorSubject<bool>.seeded(false),
    BehaviorSubject<bool>.seeded(false),
    BehaviorSubject<bool>.seeded(false),
    BehaviorSubject<bool>.seeded(false),
    BehaviorSubject<bool>.seeded(false),
    BehaviorSubject<bool>.seeded(false),
    BehaviorSubject<bool>.seeded(false),
    BehaviorSubject<bool>.seeded(false),
    BehaviorSubject<bool>.seeded(false),
    BehaviorSubject<bool>.seeded(false),
  ];

  ///Common Variables
  PageController pageViewController = PageController();
  PageController pageViewPackageController = PageController();
  BehaviorSubject<int> currentPageIndex = BehaviorSubject<int>.seeded(0);
  BehaviorSubject<bool> buildBottomBar = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<StoreItemState> itemPage = BehaviorSubject<StoreItemState>();

  final StoreItemRepo _storeItemRepo = StoreItemRepo();

  ///Add item department variables
  BehaviorSubject<StoreItemState> itemDepartmentState = BehaviorSubject<StoreItemState>();
  late ResItemDepartmentModel resItemDepartmentModel;
  BehaviorSubject<ItemDepartment?> departmentValue = BehaviorSubject<ItemDepartment?>();

  ///Add item department tax
  BehaviorSubject<StoreItemState> itemDepartmentTaxState = BehaviorSubject<StoreItemState>();
  late ResDeptTaxSlabModel resDeptTaxSlabModel;
  late ResDeptTaxSlabModel resTaxSlabModel;
  ResDeptModel? deptModel;

  ///Package variables
  BehaviorSubject<bool> ringUpValue = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<int> currentPackagePageIndex = BehaviorSubject<int>.seeded(0);
  late BehaviorSubject<StoreItemState> packagePageState;
  TextEditingController itemPackageNameController = TextEditingController();
  TextEditingController itemPackageQtyController = TextEditingController();
  TextEditingController itemPackageQtyOnHandController = TextEditingController();
  TextEditingController itemPackageUnitCostController = TextEditingController();

  TextEditingController itemDownByController = TextEditingController();
  TextEditingController itemRetailPriceController = TextEditingController();
  TextEditingController itemMarkUpController = TextEditingController();
  TextEditingController itemMarginController = TextEditingController();

  TextEditingController itemColdPriceController = TextEditingController();
  TextEditingController itemWarmPriceController = TextEditingController();

  TextEditingController itemPackUpcController = TextEditingController();

  final formPackageKeyV1 = GlobalKey<FormState>();
  final formPackageKeyV2 = GlobalKey<FormState>();

  late BehaviorSubject<bool> itemPackageNameTap;
  late BehaviorSubject<bool> itemPackageNameShowError;
  late BehaviorSubject<bool> itemPackageQtyTap;
  late BehaviorSubject<bool> itemPackageQtyShowError;
  late BehaviorSubject<ItemSizeElement?> itemPackageSize;
  late BehaviorSubject<bool> itemPackageQtyOnHandTap;
  late BehaviorSubject<bool> itemPackageUnitCostTap;
  late BehaviorSubject<bool> itemPackageUnitCostShowError;
  late BehaviorSubject<bool> itemPackageTypeShowError;

  late BehaviorSubject<bool> itemDownByTap;
  late BehaviorSubject<bool> itemRetailPriceTap;
  late BehaviorSubject<bool> itemRetailPriceShowError;

  late BehaviorSubject<bool> itemMarkupTap;
  late BehaviorSubject<bool> itemMarkupShowError;

  late BehaviorSubject<bool> itemMarginTap;
  late BehaviorSubject<bool> itemMarginShowError;

  late BehaviorSubject<bool> coldPriceTap;
  late BehaviorSubject<bool> warmPriceTap;

  late ResItemSizeCollectionModel resItemPackageSizeCollectionModel;

  List<String> packageTypeValues = ["Raw", "Box", "Bag", "Bottle", "Can"];
  List<ItemPackUpcModel> itemPackUpcList = [];
  List<PrimaryPackageListModel> itemPrimaryPackageList = [];
  List<StoreItemPriceLevelListModel> itemStoreItemPriceLevelList = [];
  List<StoreItemPriceByQuantityListModel> itemStoreItemPriceList = [];

  late BehaviorSubject<bool> rebuildPackUpcList;

  List<ItemPackageModel> itemPackageFor = [
    ItemPackageModel(name: "Sell", id: 1, code: "sel"),
    ItemPackageModel(name: "Purchase", id: 2, code: "Prse"),
    ItemPackageModel(name: "Sell & Purchase", id: 3, code: "Bth"),
  ];

  bool packageError = false;
  String packageErrorMessage = "";

  late BehaviorSubject<String?> itemPackageType;

  late BehaviorSubject<ItemPackageModel?> itemPackageForValue;

  List<ItemPackageModel> contentOfSingle = [ItemPackageModel(name: "Single", id: 1, code: "single")];

  List<ItemPackageModel> contentOfVolume = [
    ItemPackageModel(id: 1, name: 'Fluid Ounce', code: 'FlOnce'),
    ItemPackageModel(id: 2, name: 'Cup', code: 'Cp'),
    ItemPackageModel(id: 3, name: 'Pint', code: 'Pnt'),
    ItemPackageModel(id: 4, name: 'Quart', code: 'Qrt'),
    ItemPackageModel(id: 5, name: 'Gallon', code: 'Glon'),
  ];

  List<ItemPackageModel> contentOfWeight = [
    ItemPackageModel(id: 1, name: 'Ounce', code: 'Once'),
    ItemPackageModel(id: 1, name: 'Pound', code: 'Pond'),
    ItemPackageModel(id: 1, name: 'Ton ', code: 'Tn'),
  ];

  late BehaviorSubject<bool> rebuildPackagePage2;

  late BehaviorSubject<ItemPackageModel> contentTypeValue;

  ItemBloc() {
    itemNameTap = subjectManager.createSubject<bool>(key: "itemNameTap", seedValue: false);
    itemPackageNameTap = subjectManager.createSubject<bool>(key: "itemPackageNameTap", seedValue: false);
    itemPackageNameShowError =
        subjectManager.createSubject<bool>(key: "itemPackageNameShowError", seedValue: false);
    itemPackageType = subjectManager.createSubject<String?>(key: "itemPackageType");
    itemPackageTypeShowError =
        subjectManager.createSubject<bool>(key: "itemPackageTypeShowError", seedValue: false);

    itemPackageForValue = subjectManager.createSubject<ItemPackageModel?>(
      key: "itemPackageFor",
      seedValue: itemPackageFor[0],
    );
    contentTypeValue = subjectManager.createSubject<ItemPackageModel>(
      key: "contentTypeValue",
      seedValue: contentOfSingle[0],
    );
    itemPackageQtyTap = subjectManager.createSubject<bool>(key: "itemPackageQtyTap", seedValue: false);
    itemPackageQtyShowError =
        subjectManager.createSubject<bool>(key: "itemPackageQtyShowError", seedValue: false);
    packagePageState = subjectManager.createSubject<StoreItemState>(key: "packagePageState");
    itemPackageSize = subjectManager.createSubject<ItemSizeElement?>(key: "itemPackageSize");
    itemPackageQtyOnHandTap =
        subjectManager.createSubject<bool>(key: "itemPackageQtyOnHandTap", seedValue: false);
    itemPackageUnitCostTap =
        subjectManager.createSubject<bool>(key: "itemPackageUnitCostTap", seedValue: false);
    itemPackageUnitCostShowError =
        subjectManager.createSubject<bool>(key: "itemPackageUnitCostShowError", seedValue: false);

    itemDownByTap = subjectManager.createSubject<bool>(key: "itemDownByTap", seedValue: false);
    itemRetailPriceTap = subjectManager.createSubject<bool>(key: "itemRetailPriceTap", seedValue: false);
    itemRetailPriceShowError =
        subjectManager.createSubject<bool>(key: "itemRetailPriceShowError", seedValue: false);
    itemMarkupTap = subjectManager.createSubject<bool>(key: "itemMarkupTap", seedValue: false);
    itemMarkupShowError =
        subjectManager.createSubject<bool>(key: "itemMarkupShowError", seedValue: false);
    itemMarginTap = subjectManager.createSubject<bool>(key: "itemMarginTap", seedValue: false);
    itemMarginShowError =
        subjectManager.createSubject<bool>(key: "itemMarginShowError", seedValue: false);
    coldPriceTap = subjectManager.createSubject<bool>(key: "coldPriceTap", seedValue: false);
    warmPriceTap = subjectManager.createSubject<bool>(key: "warmPriceTap", seedValue: false);
    rebuildPackUpcList = subjectManager.createSubject<bool>(key: "rebuildPackUpcList", seedValue: false);
    rebuildPackagePage2 =
        subjectManager.createSubject<bool>(key: "rebuildPackagePage2", seedValue: false);
  }

  bool checkV1Validation() {
    if ((!itemNameShowError.value && itemNameController.text.isNotEmpty) &&
        (!skuShowError.value && skuController.text.isNotEmpty)) {
      return true;
    }
    return false;
  }

  void initData() {
    itemPage.add(StoreItemState.loading());
    subscription.add(
      ZipStream.zip4(_storeItemRepo.getItemCollection(), _storeItemRepo.getItemSuppliers(),
          _storeItemRepo.getScanData(), _storeItemRepo.getItemAge(),
          (resStoreItemTypeCollectionModel, resItemSuppliersModel, resScanDataModel, resItemAgeModel) {
        if (!(resStoreItemTypeCollectionModel.error ?? true) &&
            !(resItemSuppliersModel.error ?? true) &&
            !(resScanDataModel.error ?? true) &&
            !(resItemAgeModel.error ?? true)) {
          this.resStoreItemTypeCollectionModel = resStoreItemTypeCollectionModel;
          itemTypeValue.add(
            this.resStoreItemTypeCollectionModel.data!.list!.firstWhere(
                  (element) => element.name!.compareTo("Standard") == 0,
                ),
          );
          this.resItemSuppliersModel = resItemSuppliersModel;
          this.resScanDataModel = resScanDataModel;
          this.resItemAgeModel = resItemAgeModel;
          itemPage.add(StoreItemState.completed(true));
          return;
        } else {
          AppUtil.showSnackBar(
            label: resStoreItemTypeCollectionModel.message ??
                resItemSuppliersModel.message ??
                resScanDataModel.message ??
                resItemAgeModel.message ??
                "Something went wrong".i18n,
          );
          itemPage.add(StoreItemState.error(true));
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        itemPage.add(StoreItemState.error(true));
        if (error is DioException) {
          var err = error;
          var res = ResStoreItemTypeCollectionModel.fromJson(err.response?.data ?? {});
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

  ///Generate Sku
  void generateSku() {
    if (!isSkuGenerated) {
      isSkuGenerated = true;
      subscription.add(
        _storeItemRepo.getItemSku().map((event) {
          if (!(event.error ?? true)) {
            resItemSkuModel = event;
            skuController.text = event.data!.skuSeedData![0].sku!;
            skuTap.add(skuTap.value);
            return;
          } else {
            isSkuGenerated = false;
            AppUtil.showSnackBar(label: "Error while generating sku");
          }
        }).onErrorReturnWith((error, stackTrace) {
          debugPrint(error.toString());
          debugPrint(stackTrace.toString());
          isSkuGenerated = false;
          AppUtil.showSnackBar(label: "Error while generating sku");
        }).listen((event) {}),
      );
    }
  }

  ///Check Manual Sku
  void checkSku(String value) {
    subscription.add(
      _storeItemRepo.checkUpc(value).map((event) {
        if (!(event.error ?? true)) {
          if (event.data ?? true) {
            ///Error
            skuErrorMessage = "This SKU already exists".i18n;
            skuTap.add(skuTap.value);
            skuShowError.add(true);
          } else {
            skuTap.add(skuTap.value);
            skuShowError.add(false);
            skuErrorMessage = 'Please Enter SKU'.i18n;
          }
        } else {
          skuTap.add(skuTap.value);
          skuShowError.add(false);
          skuErrorMessage = 'Please Enter SKU'.i18n;
        }
      }).onErrorReturnWith((error, stackTrace) {
        skuTap.add(skuTap.value);
        skuShowError.add(false);
        skuErrorMessage = 'Please Enter SKU'.i18n;
      }).listen((event) {}),
    );
  }

  /// Add Item methods
  void getItemDepartment() {
    itemDepartmentState.add(StoreItemState.loading());
    subscription.add(
      _storeItemRepo.getItemDepartment().map((event) {
        if (!(event.error ?? true)) {
          resItemDepartmentModel = event;
          if (departmentValue.valueOrNull != null) {
            departmentValue.add(
              resItemDepartmentModel.data!.list!
                  .firstWhere((element) => departmentValue.value!.id!.compareTo(element.id!) == 0),
            );
          }
          itemDepartmentState.add(StoreItemState.completed(true));
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
          itemDepartmentState.add(StoreItemState.error(true));
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        itemDepartmentState.add(StoreItemState.error(true));
        if (error is DioException) {
          var err = error;
          var res = ResItemDepartmentModel.fromJson(err.response?.data ?? {});
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

  void postDepartment(ReqItemDeptModel reqItemDeptModel) {
    AppUtil.showLoader();
    subscription.add(
      _storeItemRepo.postDepartment(reqItemDeptModel).map((event) {
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
        if (!(event.error ?? true)) {
          AppUtil.showSnackBar(label: "Department added successfully".i18n);
          getItemDepartment();
          return;
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Error adding department".i18n);
        }
      }).onErrorReturnWith((error, stackTrace) {
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        if (error is DioException) {
          var err = error;
          var res = ResDefaultModel.fromJson(err.response?.data ?? {});
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

  /// Add item tax slab
  void getItemDeptTax() {
    itemDepartmentTaxState.add(StoreItemState.loading());

    subscription.add(
      _storeItemRepo.getDeptItemTax().map((event) {
        if (!(event.error ?? true)) {
          resDeptTaxSlabModel = event;
          List<TaxSlabModel> selectedTab = [];
          for (var element in taxSlabs) {
            if (element.value.isSelected) {
              selectedTab.add(element.value);
            }
          }
          taxSlabs.clear();
          for (var element in resDeptTaxSlabModel.data!.list!) {
            TaxSlabModel taxSlabModel = TaxSlabModel(taxSlab: element);
            var t = BehaviorSubject<TaxSlabModel>.seeded(taxSlabModel);
            taxSlabs.add(t);
          }
          if (selectedTab.isNotEmpty) {
            for (var element in taxSlabs) {
              for (var e in selectedTab) {
                if (element.value.taxSlab.id?.compareTo(e.taxSlab.id!) == 0) {
                  var t = element.value;
                  t.isSelected = true;
                  element.add(t);
                }
              }
            }
          }
          itemDepartmentTaxState.add(StoreItemState.completed(true));
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
          itemDepartmentTaxState.add(StoreItemState.error(true));
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        itemDepartmentTaxState.add(StoreItemState.error(true));
        if (error is DioException) {
          var err = error;
          var res = ResDeptTaxSlabModel.fromJson(err.response?.data ?? {});
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

  void postItemDeptTaxSlab(ReqItemTaxLabModel reqItemTaxLabModel) {
    AppUtil.showLoader();
    subscription.add(
      _storeItemRepo.postTaxSlab(reqItemTaxLabModel).map((event) {
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
        if (!(event.error ?? true)) {
          AppUtil.showSnackBar(label: "Tax slab added successfully".i18n);
          getItemDeptTax();
          return;
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Error adding tax slab".i18n);
        }
      }).onErrorReturnWith((error, stackTrace) {
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        if (error is DioException) {
          var err = error;
          var res = ResItemTaxLabModel.fromJson(err.response?.data ?? {});
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

  /// Add item category
  void getItemCategory() {
    itemCategoryState.add(StoreItemState.loading());
    subscription.add(
      _storeItemRepo.getItemTypeCategory(deptId: departmentValue.valueOrNull?.id).map((event) {
        if (!(event.error ?? false)) {
          resItemCategoryModel = event;
          if (itemCategoryValue.valueOrNull != null) {
            itemCategoryValue.add(
              resItemCategoryModel.data!.list!.where((element) {
                return itemCategoryValue.value!.id!.compareTo(element.id!) == 0;
              }).first,
            );
          }
          itemCategoryState.add(StoreItemState.completed(true));
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
          itemCategoryState.add(StoreItemState.error(true));
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        itemCategoryState.add(StoreItemState.error(true));
        if (error is DioException) {
          var err = error;
          var res = ResItemCategoryModel.fromJson(err.response?.data ?? {});
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
      }).listen(
        (event) {},
      ),
    );
  }

  /// Add item sub category
  void getSubcategory() {
    itemSubCategoryState.add(StoreItemState.loading());
    subscription.add(
      _storeItemRepo.getSubcategory(itemCategoryValue.value?.id ?? "").map((event) {
        if (!(event.error ?? true)) {
          resSubCategoryModel = event;
          if (itemSubCategoryValue.valueOrNull != null) {
            itemSubCategoryValue.add(
              resSubCategoryModel.data!.list!.where((element) {
                return itemSubCategoryValue.value!.id!.compareTo(element.id!) == 0;
              }).first,
            );
          }
          itemSubCategoryState.add(StoreItemState.completed(true));
          return;
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
          itemSubCategoryState.add(StoreItemState.error(true));
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        itemSubCategoryState.add(StoreItemState.error(true));
        if (error is DioException) {
          var err = error;
          var res = ResSubCategoryModel.fromJson(err.response?.data ?? {});
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

  ///Get department while adding category
  void getItemDepartmentCategory() {
    itemCategoryDepartmentState.add(StoreItemState.loading());
    subscription.add(
      _storeItemRepo.getItemDepartment().map((event) {
        if (!(event.error ?? true)) {
          resItemDepartmentCategoryModel = event;
          itemCategoryDepartmentState.add(StoreItemState.completed(true));
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
          itemCategoryDepartmentState.add(StoreItemState.error(true));
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        itemCategoryDepartmentState.add(StoreItemState.error(true));
        if (error is DioException) {
          var err = error;
          var res = ResItemDepartmentModel.fromJson(err.response?.data ?? {});
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

  ///Post a new category
  void postCategory(ReqItemCategoryDeptModel reqItemCategoryDeptModel) {
    AppUtil.showLoader();
    subscription.add(
      _storeItemRepo.postItemCategoryDepartment(reqItemCategoryDeptModel).map((event) {
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
        if (!(event.error ?? true)) {
          getItemCategory();
          return;
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
        if (error is DioException) {
          var err = error;
          var res = ResItemCategoryDeptModel.fromJson(err.response?.data ?? {});
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
      }).listen(
        (event) {},
      ),
    );
  }

  void getItemCategorySubModule() {
    itemSubmoduleCategoryState.add(StoreItemState.loading());
    subscription.add(
      _storeItemRepo.getItemTypeCategory().map((event) {
        if (!(event.error ?? false)) {
          resItemSubModuleCategoryModel = event;
          // if (itemCategoryValue.valueOrNull != null) {
          //   itemCategoryValue.add(
          //     resItemCategoryModel.data!.list!.where((element) {
          //       return itemCategoryValue.value.id!.compareTo(element.id!) == 0;
          //     }).first,
          //   );
          // }
          itemSubmoduleCategoryState.add(StoreItemState.completed(true));
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
          itemSubmoduleCategoryState.add(StoreItemState.error(true));
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        itemSubmoduleCategoryState.add(StoreItemState.error(true));
        if (error is DioException) {
          var err = error;
          var res = ResItemCategoryModel.fromJson(err.response?.data ?? {});
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
      }).listen(
        (event) {},
      ),
    );
  }

  ///Post a new sub category
  void postSubCategory(ReqItemSubCategoryModel reqItemSubCategoryModel) {
    AppUtil.showLoader();
    subscription.add(
      _storeItemRepo.postItemSubCategory(reqItemSubCategoryModel).map((event) {
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
        if (!(event.error ?? true)) {
          getSubcategory();
          return;
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
        }
      }).onErrorReturnWith((error, stackTrace) {
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
      }).listen((event) {}),
    );
  }

  ///Get item regions
  void getItemRegions() {
    itemRegionsState.add(StoreItemState.loading());
    subscription.add(
      _storeItemRepo.getItemRegions().map((event) {
        if (!(event.error ?? true)) {
          resItemRegionsModel = event;
          if (itemRegionsValue.valueOrNull != null) {
            itemRegionsValue.add(
              resItemRegionsModel.data!.list!
                  .firstWhere((element) => itemRegionsValue.value!.id!.compareTo(element.id!) == 0),
            );
          }
          itemRegionsState.add(StoreItemState.completed(true));
          return;
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
          itemRegionsState.add(StoreItemState.error(true));
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        itemSubmoduleCategoryState.add(StoreItemState.error(true));
        if (error is DioException) {
          var err = error;
          var res = ResItemRegionsModel.fromJson(err.response?.data ?? {});
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

  ///Post item regions
  void postItemRegions(ReqItemRegionsModel regionsModel) {
    AppUtil.showLoader();
    subscription.add(
      _storeItemRepo.postRegions(regionsModel).map((event) {
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
        if (!(event.error ?? true)) {
          AppUtil.showSnackBar(label: "Region added successfully".i18n);
          getItemRegions();
          return;
        } else {
          debugPrint(event.message.toString());
          AppUtil.showSnackBar(label: "Error adding Region".i18n);
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
        if (error is DioException) {
          var err = error;
          var res = ResDefaultModel.fromJson(err.response?.data ?? {});
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

  ///Get item abv
  void getItemAvc() {
    itemAbvState.add(StoreItemState.loading());
    subscription.add(
      _storeItemRepo.getItemAbv().map((event) {
        if (!(event.error ?? true)) {
          resItemAbvModel = event;
          if (itemAbvValue.valueOrNull != null) {
            itemAbvValue.add(
              resItemAbvModel.data!.list!
                  .firstWhere((element) => element.id!.compareTo(itemAbvValue.value!.id!) == 0),
            );
          }
          itemAbvState.add(StoreItemState.completed(true));
          return;
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
          itemAbvState.add(StoreItemState.error(true));
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        itemAbvState.add(StoreItemState.error(true));
        if (error is DioException) {
          var err = error;
          var res = ResItemAbvModel.fromJson(err.response?.data ?? {});
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

  ///Post item abv
  void postItemAbv(ReqItemRegionsModel regionsModel) {
    AppUtil.showLoader();
    subscription.add(
      _storeItemRepo.postAbv(regionsModel).map((event) {
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
        if (!(event.error ?? true)) {
          AppUtil.showSnackBar(label: "Alcohol by volume added successfully".i18n);
          getItemAvc();
          return;
        } else {
          debugPrint(event.message.toString());
          AppUtil.showSnackBar(label: "Error adding Alcohol by volume".i18n);
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
        if (error is DioException) {
          var err = error;
          var res = ResDefaultModel.fromJson(err.response?.data ?? {});
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

  ///Get item flavour
  void getItemFlavour() {
    itemFlavourState.add(StoreItemState.loading());
    subscription.add(
      _storeItemRepo.getFlavour().map((event) {
        if (!(event.error ?? true)) {
          resItemFlavourModel = event;
          if (itemFlavourValue.valueOrNull != null) {
            itemFlavourValue.add(
              resItemFlavourModel.data!.list!
                  .firstWhere((element) => element.id!.compareTo(itemFlavourValue.value!.id!) == 0),
            );
          }
          itemFlavourState.add(StoreItemState.completed(true));
          return;
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
          itemFlavourState.add(StoreItemState.error(true));
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        itemFlavourState.add(StoreItemState.error(true));
        if (error is DioException) {
          var err = error;
          var res = ResItemFlavourModel.fromJson(err.response?.data ?? {});
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

  ///Post item flavour
  void postItemFlavour(ReqItemRegionsModel regionsModel) {
    AppUtil.showLoader();
    subscription.add(
      _storeItemRepo.postFlavour(regionsModel).map((event) {
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
        if (!(event.error ?? true)) {
          AppUtil.showSnackBar(label: "Flavour added successfully".i18n);
          getItemFlavour();
          return;
        } else {
          debugPrint(event.message.toString());
          AppUtil.showSnackBar(label: "Error adding Flavour".i18n);
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
        if (error is DioException) {
          var err = error;
          var res = ResDefaultModel.fromJson(err.response?.data ?? {});
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

  ///Get item flavour
  void getItemFamily() {
    itemFamilyState.add(StoreItemState.loading());
    subscription.add(
      _storeItemRepo.getFamily().map((event) {
        if (!(event.error ?? true)) {
          resItemFamilyModel = event;
          if (itemFamilyValue.valueOrNull != null) {
            itemFamilyValue.add(
              resItemFamilyModel.data!.list!
                  .firstWhere((element) => element.id!.compareTo(itemFamilyValue.value!.id!) == 0),
            );
          }
          itemFamilyState.add(StoreItemState.completed(true));
          return;
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
          itemFamilyState.add(StoreItemState.error(true));
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        itemFamilyState.add(StoreItemState.error(true));
        if (error is DioException) {
          var err = error;
          var res = ResItemFlavourModel.fromJson(err.response?.data ?? {});
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

  ///Post item family
  void postItemFamily(ReqItemRegionsModel regionsModel) {
    AppUtil.showLoader();
    subscription.add(
      _storeItemRepo.postFamily(regionsModel).map((event) {
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
        if (!(event.error ?? true)) {
          AppUtil.showSnackBar(label: "Family added successfully".i18n);
          getItemFamily();
          return;
        } else {
          debugPrint(event.message.toString());
          AppUtil.showSnackBar(label: "Error adding Family".i18n);
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
        if (error is DioException) {
          var err = error;
          var res = ResDefaultModel.fromJson(err.response?.data ?? {});
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

  ///Get item flavour
  void getItemVintage() {
    itemVintageState.add(StoreItemState.loading());
    subscription.add(
      _storeItemRepo.getVintage().map((event) {
        if (!(event.error ?? true)) {
          resItemVintageModel = event;
          if (itemVintageValue.valueOrNull != null) {
            itemVintageValue.add(
              resItemVintageModel.data!.list!
                  .firstWhere((element) => element.id!.compareTo(itemVintageValue.value!.id!) == 0),
            );
          }
          itemVintageState.add(StoreItemState.completed(true));
          return;
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
          itemVintageState.add(StoreItemState.error(true));
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        itemVintageState.add(StoreItemState.error(true));
        if (error is DioException) {
          var err = error;
          var res = ResItemFlavourModel.fromJson(err.response?.data ?? {});
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

  ///Post item family
  void postItemVintage(ReqItemRegionsModel regionsModel) {
    AppUtil.showLoader();
    subscription.add(
      _storeItemRepo.postVintage(regionsModel).map((event) {
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
        if (!(event.error ?? true)) {
          AppUtil.showSnackBar(label: "Vintage added successfully".i18n);
          getItemVintage();
          return;
        } else {
          debugPrint(event.message.toString());
          AppUtil.showSnackBar(label: "Error adding Vintage".i18n);
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
        if (error is DioException) {
          var err = error;
          var res = ResDefaultModel.fromJson(err.response?.data ?? {});
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

  /// get item tax slab
  void getItemTax() {
    itemDepartmentTaxState.add(StoreItemState.loading());
    subscription.add(
      _storeItemRepo.getDeptItemTax().map((event) {
        if (!(event.error ?? true)) {
          resTaxSlabModel = event;
          List<TaxSlabModel> selectedTab = [];
          for (var element in itemTaxSlabs) {
            if (element.value.isSelected) {
              selectedTab.add(element.value);
            }
          }
          itemTaxSlabs.clear();
          for (var element in resTaxSlabModel.data!.list!) {
            TaxSlabModel taxSlabModel = TaxSlabModel(taxSlab: element);
            // var t = BehaviorSubject<TaxSlabModel>.seeded(taxSlabModel);
            var t = subjectManager.createSubject<TaxSlabModel>(
              key: taxSlabModel.taxSlab.id!,
              seedValue: taxSlabModel,
            );
            itemTaxSlabs.add(t);
          }
          if (selectedTab.isNotEmpty) {
            for (var element in itemTaxSlabs) {
              for (var e in selectedTab) {
                if (element.value.taxSlab.id?.compareTo(e.taxSlab.id!) == 0) {
                  var t = element.value;
                  t.isSelected = true;
                  element.add(t);
                }
              }
            }
          }
          getDeptTaxList();
          return;
          //itemDepartmentTaxState.add(StoreItemState.completed(true));
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
          itemDepartmentTaxState.add(StoreItemState.error(true));
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        itemDepartmentTaxState.add(StoreItemState.error(true));
        if (error is DioException) {
          var err = error;
          var res = ResDeptTaxSlabModel.fromJson(err.response?.data ?? {});
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

  void getDeptTaxList() {
    if (departmentValue.valueOrNull != null) {
      StoreItemRepo().getTaxDepartmentCollection(departmentValue.valueOrNull!.id!).map((event) {
        if (!(event.error ?? true)) {
          deptModel = event;
          //taxSlabAllowed.value = true;
          // for (var element in deptModel!.data!.taxSlabIdList!) {
          //   if(element.compareTo(other))
          // }
          itemDepartmentTaxState.add(StoreItemState.completed(true));
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
          itemDepartmentTaxState.add(StoreItemState.error(true));
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        itemDepartmentTaxState.add(StoreItemState.error(true));
        if (error is DioException) {
          var err = error;
          var res = ResDeptTaxSlabModel.fromJson(err.response?.data ?? {});
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
      }).listen((event) {});
    } else {
      itemDepartmentTaxState.add(StoreItemState.completed(true));
    }
  }

  void postItemTaxSlab(ReqItemTaxLabModel reqItemTaxLabModel) {
    AppUtil.showLoader();
    subscription.add(
      _storeItemRepo.postTaxSlab(reqItemTaxLabModel).map((event) {
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
        if (!(event.error ?? true)) {
          AppUtil.showSnackBar(label: "Tax slab added successfully".i18n);
          getItemTax();
          return;
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Error adding tax slab".i18n);
        }
      }).onErrorReturnWith((error, stackTrace) {
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentContext);
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        if (error is DioException) {
          var err = error;
          var res = ResItemTaxLabModel.fromJson(err.response?.data ?? {});
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

  /// Get initial data of packaging
  void initPackageData() {
    packagePageState.add(StoreItemState.loading());
    subscription.add(
      _storeItemRepo.getItemPackageSizeCollection().map((event) {
        if (!(event.error ?? true)) {
          resItemPackageSizeCollectionModel = event;
          packagePageState.add(StoreItemState.completed(true));
          return;
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
          packagePageState.add(StoreItemState.error(true));
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        packagePageState.add(StoreItemState.error(true));
        if (error is DioException) {
          var err = error;
          var res = ResItemSizeCollectionModel.fromJson(err.response?.data ?? {});
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

  ///Package page 1 validation
  bool checkPackageV1Validation() {
    if ((!itemPackageNameShowError.value && itemPackageNameController.text.isNotEmpty) &&
        (!itemPackageQtyShowError.value && itemPackageQtyController.text.isNotEmpty) &&
        (!itemPackageUnitCostShowError.value && itemPackageUnitCostController.text.isNotEmpty)) {
      if (itemPackageType.valueOrNull == null) {
        itemPackageTypeShowError.add(true);
      } else {
        itemPackageTypeShowError.add(false);
        if (uomValue.value.compareTo("Unit") == 0) {
          if (itemPackageSize.valueOrNull == null) {
            AppUtil.showSnackBar(label: "Please select a size".i18n);
            return false;
          }
        }
        return true;
      }
    }
    if (itemPackageType.valueOrNull == null) {
      itemPackageTypeShowError.add(true);
    } else {
      itemPackageTypeShowError.add(false);
    }
    return false;
  }

  bool checkPackageV2Validation() {
    if (itemPackageForValue.value!.code.compareTo("Prse") != 0) {
      if ((!itemRetailPriceShowError.value && itemRetailPriceController.text.isNotEmpty) &&
          (!itemMarkupShowError.value && itemMarkUpController.text.isNotEmpty) &&
          (!itemMarginShowError.value && itemMarginController.text.isNotEmpty)) {
        if (itemPackUpcList.isNotEmpty) {
          return true;
        }
        AppUtil.showSnackBar(label: "Please create a UPC".i18n);
        return false;
      }
    }
    if (itemPackUpcList.isNotEmpty) {
      return true;
    }
    AppUtil.showSnackBar(label: "Please create a UPC".i18n);
    return false;
  }

  /// Add Upc
  void addUpc(String upcName) {
    if (itemPackUpcList.isNotEmpty) {
      for (var element in itemPackUpcList) {
        if (element.packUpcName.compareTo(upcName) == 0) {
          AppUtil.showSnackBar(label: "This UPC already exist".i18n);
          return;
        }
      }
    }
    AppUtil.showLoader();
    subscription.add(
      _storeItemRepo.addPackUpc(upcName).map((event) {
        AppUtil.hideLoader(
          context: AppRouteManager.navigatorKey.currentContext!,
        );
        if (!(event.error ?? true)) {
          if (!(event.data ?? true)) {
            ItemPackUpcModel item = ItemPackUpcModel(
              packUpcName: upcName,
            );
            itemPackUpcList.add(item);

            rebuildPackUpcList.add(true);
            AppUtil.showSnackBar(label: "UPC added successfully".i18n);
          } else {
            AppUtil.showSnackBar(label: "This UPC already exist".i18n);
          }
        } else {
          AppUtil.showSnackBar(label: event.message ?? "Something went wrong".i18n);
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        AppUtil.hideLoader(
          context: AppRouteManager.navigatorKey.currentContext!,
        );
        AppUtil.showSnackBar(label: "Something went wrong".i18n);
      }).listen((event) {}),
    );
  }

  ///Generate Pack upc
  void generatePackUpc() {
    AppUtil.showLoader();
    subscription.add(
      _storeItemRepo.generatePackUpc().map((event) {
        AppUtil.hideLoader(
          context: AppRouteManager.navigatorKey.currentContext!,
        );
        if (!(event.error ?? true)) {
          var item = ItemPackUpcModel(
            packUpcName: event.data!.upcSeedData!.first.upc!,
            packUpcPoolId: event.data!.upcSeedData!.first.id!,
          );
          itemPackUpcList.add(item);
          rebuildPackUpcList.add(true);
          AppUtil.showSnackBar(label: "UPC added successfully".i18n);
        } else {
          AppUtil.showSnackBar(label: "Something went wrong".i18n);
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        AppUtil.hideLoader(
          context: AppRouteManager.navigatorKey.currentContext!,
        );
        AppUtil.showSnackBar(label: "Something went wrong".i18n);
      }).listen((event) {}),
    );
  }

  ///Mark up margin calculation
  void marginMarkupCalculation() {
    if (itemPackageUnitCostController.text.isNotEmpty && itemRetailPriceController.text.isNotEmpty) {
      double unitCost = double.parse(
            itemPackageUnitCostController.text.isEmpty
                ? "0.0"
                : double.parse(itemPackageUnitCostController.text).toStringAsFixed(2),
          ) -
          double.parse(
            itemDownByController.text.isEmpty
                ? "0.0"
                : double.parse(itemDownByController.text).toStringAsFixed(2),
          );
      double difference = double.parse(
            itemRetailPriceController.text.isEmpty
                ? "0.0"
                : double.parse(itemRetailPriceController.text).toStringAsFixed(2),
          ) -
          unitCost;
      if (difference < 0) {
        difference = 0;
      }
      double marginAmt = difference /
          double.parse(
            itemRetailPriceController.text.isEmpty
                ? "0.0"
                : double.parse(itemRetailPriceController.text).toStringAsFixed(2),
          );
      double markUpAmt = difference / unitCost;
      double margin = marginAmt * 100;
      double markup = markUpAmt * 100;
      if (margin > 0) {
        itemMarginController.text = margin.toStringAsFixed(2);
      } else {
        itemMarginController.text = "0";
      }

      if (markup > 0) {
        itemMarkUpController.text = markup.toStringAsFixed(2);
      } else {
        itemMarkUpController.text = "0";
      }
    }
  }

  void retailMarginCalculation() {
    double margin = 0;
    double retailPrice = 0;
    double downBy = double.parse(
      itemDownByController.text.isEmpty
          ? "0.0"
          : double.parse(itemDownByController.text).toStringAsFixed(2),
    );
    double markUp = double.parse(
      itemMarkUpController.text.isEmpty
          ? "0.0"
          : double.parse(itemMarkUpController.text).toStringAsFixed(2),
    );
    double unit = double.parse(
      itemPackageUnitCostController.text.isEmpty
          ? "0.0"
          : double.parse(itemPackageUnitCostController.text).toStringAsFixed(2),
    );

    if (unit != 0 && markUp != 0) {
      double unitCost = unit - downBy;
      double unitPrice = unitCost + unitCost * markUp / 100;
      margin = ((unitPrice - unitCost) / unitPrice) * 100;
      retailPrice = unitPrice;
      if (margin > 0) {
        itemMarginController.text = margin.toStringAsFixed(2);
      } else {
        itemMarginController.text = "0";
      }

      if (retailPrice > 0) {
        itemRetailPriceController.text = margin.toStringAsFixed(2);
      } else {
        itemRetailPriceController.text = "0";
      }
    }
  }

  void retailMarkupCalculation() {
    double markup = 0;
    double retailPrice = 0;
    double downBy = double.parse(
      itemDownByController.text.isEmpty
          ? "0.0"
          : double.parse(itemDownByController.text).toStringAsFixed(2),
    );
    double margin = double.parse(
      itemMarginController.text.isEmpty
          ? "0.0"
          : double.parse(itemMarginController.text).toStringAsFixed(2),
    );
    double unit = double.parse(
      itemPackageUnitCostController.text.isEmpty
          ? "0.0"
          : double.parse(itemPackageUnitCostController.text).toStringAsFixed(2),
    );
    if (unit != 0 && margin != 0) {
      double unitCost = unit - downBy;
      double unitPrice = unitCost / (1 - (margin / 100));
      markup = ((unitPrice * ((margin / 100))) / unitCost) * 100;

      retailPrice = unitPrice;
      if (markup > 0) {
        itemMarkUpController.text = markup.toStringAsFixed(2);
      } else {
        itemMarkUpController.text = "0";
      }

      if (retailPrice > 0) {
        itemRetailPriceController.text = retailPrice.toStringAsFixed(2);
      } else {
        itemRetailPriceController.clear();
      }
    }
  }

  void addPackage() {
    String tempPackGuid = newGuid();
    if (itemTypeValue.value!.code!.compareTo("MP") != 0) {
      itemPrimaryPackageList.clear();
    }
    if ((uomValue.value.compareTo("Unit") != 0 && (itemPrimaryPackageList.isNotEmpty))) {
      PrimaryPackageListModel model = itemPrimaryPackageList.first;
      model.packageName = "${model.packageName} - Open (Raw)";
      itemPrimaryPackageList.first = model;
    }
    PrimaryPackageListModel primaryPackage = PrimaryPackageListModel(
      id: Flavors.getGuid()!,
      actionFlag: 1,
      basePack: itemPrimaryPackageList.isEmpty ? true : false,
      downBy: double.parse(
        itemDownByController.text.isEmpty
            ? "0.0"
            : double.parse(itemDownByController.text).toStringAsFixed(2),
      ),
      changedAt: 1,
      changedSystem: 1,
      coldPrice: itemColdPriceController.text.isEmpty
          ? 0.0
          : double.parse(double.parse(itemColdPriceController.text).toStringAsFixed(2)),
      margin: itemMarginController.text.isEmpty
          ? "0.0"
          : double.parse(itemMarginController.text).toStringAsFixed(2),
      markup: itemMarkUpController.text.isEmpty
          ? "0.0"
          : double.parse(itemMarkUpController.text).toStringAsFixed(2),
      packageContentQty: 1,
      packageContentUomType: uomValue.value.compareTo("Unit") == 0
          ? 1
          : uomValue.value.compareTo("Volume") == 0
              ? 2
              : 3,
      packageName: itemPackageNameController.text,
      packageQty: 0,
      packageType: packageType(),
      qtyUpdateAction: 0,
      retailPrice: itemRetailPriceController.text.isEmpty
          ? "0.0"
          : double.parse(itemRetailPriceController.text).toStringAsFixed(2),
      sellOrPurchase: itemPackageForValue.value!.name.compareTo("Sell & Purchase") == 0 ? 1 : 0,
      sizeId: itemPackageSize.valueOrNull?.id ?? Flavors.getGuid()!,
      tempPackId: tempPackGuid,
      upcList: itemPackUpcList.map((e) {
        return UpcList(
          actionFlag: 1,
          id: Flavors.getGuid()!,
          packReferenceId: Flavors.getGuid()!,
          packReferenceType: 1,
          upc: e.packUpcName,
          upcPoolId: e.packUpcPoolId,
          tempPackId: tempPackGuid,
          upcStatus: true,
        );
      }).toList(),
      unitCost: itemPackageUnitCostController.text.isEmpty
          ? "0.0"
          : double.parse(itemPackageUnitCostController.text).toStringAsFixed(2),
      warmPrice: itemWarmPriceController.text.isEmpty
          ? 0.0
          : double.parse(double.parse(itemWarmPriceController.text).toStringAsFixed(2)),
      weightedUnitCost: itemPackageUnitCostController.text.isEmpty
          ? "0.0"
          : double.parse(itemPackageUnitCostController.text).toStringAsFixed(2),
      packReferenceType: 1,
      printablePackageName: "${itemPackageNameController.text} - ${itemPackageSize.value} ( 1 )",
    );

    itemPrimaryPackageList.add(primaryPackage);
    resetPackageValue();
  }

  void resetPackageValue() {
    itemColdPriceController.clear();
    itemDownByController.clear();
    itemMarginController.clear();
    itemMarkUpController.clear();

    itemPackageNameController.clear();
    itemPackageType.add(null);
    itemPackageSize.add(null);
    itemRetailPriceController.clear();
    itemPackageForValue.add(itemPackageFor[0]);
    itemPackUpcList.clear();
    itemPackageUnitCostController.clear();
    itemWarmPriceController.clear();
  }

  int packageType() {
    if (itemPackageType.value!.compareTo("Box") == 0) {
      return 1;
    } else if (itemPackageType.value!.compareTo("Bag") == 0) {
      return 2;
    } else if (itemPackageType.value!.compareTo("Bottle") == 0) {
      return 3;
    } else if (itemPackageType.value!.compareTo("Can") == 0) {
      return 4;
    }
    return 5;
  }

  String newGuid() {
    const String template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx';
    Random random = Random();
    String result = template.replaceAllMapped(RegExp('[xy]'), (match) {
      int r = random.nextInt(16);
      int v = match.group(0) == 'x' ? r : (r & 0x3 | 0x8);
      return v.toRadixString(16);
    });
    return result;
  }

  /// Adding item
  Future<void> addItem() async {
    ReqItemPackageModel reqItemPackageModel = ReqItemPackageModel(
      primaryPackageListModel: itemPrimaryPackageList,
      storeItemGeneralInfoModel: StoreItemGeneralInfoModel(
        openPrice: triggersValue[0].value,
        nonRevenue: triggersValue[1].value,
        nonReturn: triggersValue[2].value,
        ebt: triggersValue[3].value,
        wic: triggersValue[4].value,
        deliplu: triggersValue[5].value,
        openQty: triggersValue[6].value,
        inActive: triggersValue[7].value,
        nonDiscountable: triggersValue[8].value,
        nonTransferable: triggersValue[9].value,
        noCreditCard: triggersValue[10].value,
        nonStocable: triggersValue[11].value,
        itemAge: itemShelfLifeController.text.isEmpty ? null : int.parse(itemShelfLifeController.text),
        packDialogShow: ringUpValue.valueOrNull,
        sellBelowCost: false,
      ),
      storeItemModel: StoreItemModel(
        itemAge: 0,
        storeId: RootBloc.store?.id,
        abbreviationId: itemAbvValue.valueOrNull?.id ?? Flavors.getGuid(),
        ageId: ageValue.valueOrNull?.id ?? Flavors.getGuid(),
        countryId: itemCountrySelected?.id.toString() ?? "",
        familyId: itemFamilyValue.valueOrNull?.id ?? Flavors.getGuid(),
        flavourId: itemFlavourValue.valueOrNull?.id ?? Flavors.getGuid(),
        generalInfoId: Flavors.getGuid(),
        id: Flavors.getGuid(),
        image: await _getItemImage(),

        ///
        inActive: triggersValue[7].value,
        itemCatId: itemCategoryValue.valueOrNull?.id ?? Flavors.getGuid(),
        itemDeptId: departmentValue.valueOrNull?.id ?? Flavors.getGuid(),
        itemId: Flavors.getGuid(),
        itemSelfLife: itemShelfLifeController.text,
        itemSubCatId: itemSubCategoryValue.valueOrNull?.id ?? "",
        itemTypeId: itemTypeValue.valueOrNull?.id ?? Flavors.getGuid(),
        name: itemNameController.text,
        nonTaxable: taxSlabAllowed.value,

        ///
        notes: "",
        regionId: itemRegionsValue.valueOrNull?.id ?? Flavors.getGuid(),
        sku: skuController.text,
        skuPoolId: resItemSkuModel?.data?.skuSeedData?[0].id ?? Flavors.getGuid(),

        ///
        skuPoolType: isSkuGenerated ? 2 : 1,
        scanData: scanDataAllowed.value,
        scanDataId: itemScanValue.valueOrNull?.id ?? Flavors.getGuid(),

        ///
        syncLocally: true,
        uomType: uomValue.value.compareTo("Unit") == 0
            ? 1
            : uomValue.value.compareTo("Volume") == 0
                ? 2
                : 3,
        vintageId: itemVintageValue.valueOrNull?.id ?? Flavors.getGuid(),
        webInfoId: Flavors.getGuid(),
        zoneId: Flavors.getGuid(),
        supplierId: Flavors.getGuid(),
      ),
      storeItemWebInfoModel: StoreItemWebInfoModel(
        description: "",
        name: "",
        note: "",
        price: 0,
        webInfoImages: [],
      ),
      taxSlabListModel: taxSlabs.isEmpty
          ? null
          : taxSlabs
              .map(
                (e) => TaxSlabListModel(
                  id: e.value.taxSlab.id,
                  actionFlag: ActionFlagEnum.insert,
                  taxSlabId: e.value.taxSlab.id,
                  taxSlabName: e.value.taxSlab.name,
                ),
              )
              .toList(),
      storeItemPriceByQuantityListModel: itemStoreItemPriceList,
      storeItemPriceLevelListModel: itemStoreItemPriceLevelList,
    );

    AppUtil.showLoader();
    subscription.add(
      _storeItemRepo.postItemData(reqItemPackageModel).map((event) {
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentState!.context);
        if (!(event.error ?? true)) {
          AppUtil.showSnackBar(label: "Item added successfully".i18n);
          TabNavigatorRouter(
            navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
            currentPageKey: AppRouteManager.currentPage,
          ).pop();
        } else {
          AppUtil.showSnackBar(
            label: event.message ?? "Something went wrong".i18n,
          );
        }
      }).onErrorReturnWith((error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        AppUtil.hideLoader(context: AppRouteManager.navigatorKey.currentState!.context);
        AppUtil.showSnackBar(
          label: "Something went wrong".i18n,
        );
      }).listen((event) {}),
    );
  }

  Future<String?> _getItemImage() async {
    if (pickedImage.valueOrNull != null) {
      List<int> imageBytes = await pickedImage.value!.readAsBytes();
      return base64Encode(imageBytes);
    }
    return "";
  }
}

class ApiConstants {
  ///Version 1
  static const String version = "v1";

  ///Authentication API V1
  static const String authAPINameV1 = 'AccessAPI/api/$version';
  static const String getAuthProfileUsers = '$authAPINameV1/AuthProfileUsers';

  ///Storeconst API V1
  static const String storeAPINameV1 = 'StoreAPI/api/$version';
  static const String getStoreApi = '$storeAPINameV1/stores';

  ///Store Items api endpoints
  static const String storeItemApi = "StoreAPI/api/$version/storeItems";
  static const String storeItemTypesCollection = "/CollectionsAPI/api/$version/ItemTypesCollection";
  static const String storeItemSizeCollection = "/CollectionsAPI/api/$version/ItemSizeCollections";
  static const String itemPack = "AdminUtilitiesAPI/api/$version/ItemPack";
  static const String scanData = "AdminUtilitiesAPI/api/$version/Scandata";
  static const String itemDepartmentCollection = "/CollectionsAPI/api/$version/ItemDepartmentCollection";
  static const String taxSlabs = "/storeapi/api/$version/TaxSlabs";
  static const String itemCategoryCollection = "/CollectionsAPI/api/$version/ItemCategoryCollection";
  static const String itemSubcategoryCollection =
      "/CollectionsAPI/api/$version/ItemSubCategoriesCollection";
  static const String distributorCompany = "/SuppliersAPI/api/$version/Distributors";

  ///Employee Api Endpoints
  static const String employeeListApi = "AccessAPI/api/$version/StoreProfileUsers";
  static const String storeRoles = "/AccessAPI/api/$version/StoreRoles";
  static const String zipUtility = "/LicenseUtilitiesAPI/api/$version/Locations/ZipOrigine";
  static const String addEmployee = "AccessAPI/api/$version/StoreProfileUsers";

  ///Add item Api Endpoints
  static const String itemType = "/CollectionsAPI/api/$version/ItemTypesCollection";
  static const String itemDepartment = "/CollectionsAPI/api/$version/ItemDepartmentCollection";
  static const String itemTax = "storeapi/api/$version/TaxSlabs";

  static const String itemCategory = "/CollectionsAPI/api/$version/ItemCategoryCollection";
  static const String skuGenerate = "/LicenseUtilitiesAPI/api/$version/SeedDataTriggers/Sku";

  static const String itemCountry = "/LicenseUtilitiesAPI/api/$version/Locations/Countries";
  static const String itemRegions = "/ItemsAPI/api/$version/StoreItemRegions";

  static const String itemAbv = "/AdminUtilitiesAPI/api/$version/abbreviations";
  static const String itemFlavour = "/ItemsAPI/api/$version/StoreItemFlavors";

  static const String itemAge = "/AdminUtilitiesAPI/api/$version/Ages";
  static const String itemFamily = "/ItemsAPI/api/$version/StoreItemFamilies";

  static const String itemVintage = "/ItemsAPI/api/$version/StoreItemVintages";
  static const String itemsSuppliers = "/SuppliersAPI/api/$version/Suppliers";

  static const String itemPackUpc = "/StoreAPI/api/$version/StoreItemAttributesCheck";
  static const String itemPackUpcGenerate = "/LicenseUtilitiesAPI/api/$version/SeedDataTriggers/Upc";

  /// Triggers api
  static const String getTpr = "/StoreAPI/api/$version/TprTriggers";
  static const String getTriggersStoreItemPackage = "/StoreAPI/api/$version/TprTriggers";

  /// Quick access api
  static const String getQuickAccess = "/StoreAPI/api/$version/QuickAccessGroups";

  /// Standard discount api
  static const String standardDiscountApi = "/StoreAPI/api/$version/StoreStandardDiscount";
  static const String getStandardStores = "/storeapi/api/$version/Stores";

  /// Price Levels api
  static const String priceLevelApi = "/CollectionsAPI/api/$version/PriceLevels";
}

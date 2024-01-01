class ReqItemPackageModel {
  StoreItemModel? storeItemModel;
  StoreItemGeneralInfoModel? storeItemGeneralInfoModel;
  dynamic storeItemVariantListModel;
  dynamic storeItemDistributorListModel;
  StoreItemWebInfoModel? storeItemWebInfoModel;
  dynamic storeItemLocationListModel;
  dynamic storeItemFlashSaleListModel;
  List<TaxSlabListModel>? taxSlabListModel;
  dynamic storeItemAlongListModel;
  dynamic storeItemModifierListModel;
  List<StoreItemPriceLevelListModel>? storeItemPriceLevelListModel;
  List<StoreItemPriceByQuantityListModel>? storeItemPriceByQuantityListModel;
  List<PrimaryPackageListModel>? primaryPackageListModel;
  List<dynamic>? secondaryPackageListModel;
  List<dynamic>? tertiaryPackageListModel;

  ReqItemPackageModel({
    this.storeItemModel,
    this.storeItemGeneralInfoModel,
    this.storeItemVariantListModel,
    this.storeItemDistributorListModel,
    this.storeItemWebInfoModel,
    this.storeItemLocationListModel,
    this.storeItemFlashSaleListModel,
    this.taxSlabListModel,
    this.storeItemAlongListModel,
    this.storeItemModifierListModel,
    this.storeItemPriceLevelListModel,
    this.storeItemPriceByQuantityListModel,
    this.primaryPackageListModel,
    this.secondaryPackageListModel,
    this.tertiaryPackageListModel,
  });

  factory ReqItemPackageModel.fromJson(Map<String, dynamic> json) => ReqItemPackageModel(
        storeItemModel:
            json["StoreItemModel"] == null ? null : StoreItemModel.fromJson(json["StoreItemModel"]),
        storeItemGeneralInfoModel: json["StoreItemGeneralInfoModel"] == null
            ? null
            : StoreItemGeneralInfoModel.fromJson(json["StoreItemGeneralInfoModel"]),
        storeItemVariantListModel: json["StoreItemVariantListModel"],
        storeItemDistributorListModel: json["StoreItemDistributorListModel"],
        storeItemWebInfoModel: json["StoreItemWebInfoModel"] == null
            ? null
            : StoreItemWebInfoModel.fromJson(json["StoreItemWebInfoModel"]),
        storeItemLocationListModel: json["StoreItemLocationListModel"],
        storeItemFlashSaleListModel: json["StoreItemFlashSaleListModel"],
        taxSlabListModel: json["TaxSlabListModel"] == null
            ? []
            : List<TaxSlabListModel>.from(
                json["TaxSlabListModel"]!.map((x) => TaxSlabListModel.fromJson(x)),
              ),
        storeItemAlongListModel: json["StoreItemAlongListModel"],
        storeItemModifierListModel: json["StoreItemModifierListModel"],
        storeItemPriceLevelListModel: json["StoreItemPriceLevelListModel"] == null
            ? []
            : List<StoreItemPriceLevelListModel>.from(
                json["StoreItemPriceLevelListModel"]!
                    .map((x) => StoreItemPriceLevelListModel.fromJson(x)),
              ),
        storeItemPriceByQuantityListModel: json["StoreItemPriceByQuantityListModel"] == null
            ? []
            : List<StoreItemPriceByQuantityListModel>.from(
                json["StoreItemPriceByQuantityListModel"]!
                    .map((x) => StoreItemPriceByQuantityListModel.fromJson(x)),
              ),
        primaryPackageListModel: json["PrimaryPackageListModel"] == null
            ? []
            : List<PrimaryPackageListModel>.from(
                json["PrimaryPackageListModel"]!.map((x) => PrimaryPackageListModel.fromJson(x)),
              ),
        secondaryPackageListModel: json["SecondaryPackageListModel"] == null
            ? []
            : List<dynamic>.from(json["SecondaryPackageListModel"]!.map((x) => x)),
        tertiaryPackageListModel: json["TertiaryPackageListModel"] == null
            ? []
            : List<dynamic>.from(json["TertiaryPackageListModel"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "StoreItemModel": storeItemModel?.toJson(),
        "StoreItemGeneralInfoModel": storeItemGeneralInfoModel?.toJson(),
        "StoreItemVariantListModel": storeItemVariantListModel,
        "StoreItemDistributorListModel": storeItemDistributorListModel,
        "StoreItemWebInfoModel": storeItemWebInfoModel?.toJson(),
        "StoreItemLocationListModel": storeItemLocationListModel,
        "StoreItemFlashSaleListModel": storeItemFlashSaleListModel,
        "TaxSlabListModel":
            taxSlabListModel == null ? [] : List<dynamic>.from(taxSlabListModel!.map((x) => x.toJson())),
        "StoreItemAlongListModel": storeItemAlongListModel,
        "StoreItemModifierListModel": storeItemModifierListModel,
        "StoreItemPriceLevelListModel": storeItemPriceLevelListModel == null
            ? []
            : List<dynamic>.from(storeItemPriceLevelListModel!.map((x) => x.toJson())),
        "StoreItemPriceByQuantityListModel": storeItemPriceByQuantityListModel == null
            ? []
            : List<dynamic>.from(storeItemPriceByQuantityListModel!.map((x) => x.toJson())),
        "PrimaryPackageListModel": primaryPackageListModel == null
            ? []
            : List<dynamic>.from(primaryPackageListModel!.map((x) => x.toJson())),
        "SecondaryPackageListModel": secondaryPackageListModel == null
            ? []
            : List<dynamic>.from(secondaryPackageListModel!.map((x) => x)),
        "TertiaryPackageListModel": tertiaryPackageListModel == null
            ? []
            : List<dynamic>.from(tertiaryPackageListModel!.map((x) => x)),
      };
}

class PrimaryPackageListModel {
  String? id;
  String? tempPackId;
  String? packageName;
  String? printablePackageName;
  int? packageType;
  int? sellOrPurchase;
  int? packReferenceType;
  int? packageContentUomType;
  String? sizeId;
  int? packageContentQty;
  String? unitCost;
  String? weightedUnitCost;
  String? margin;
  String? markup;
  String? retailPrice;
  double? downBy;
  double? coldPrice;
  double? warmPrice;
  int? packageQty;
  int? qtyUpdateAction;
  dynamic upc;
  int? actionFlag;
  bool? basePack;
  List<UpcList>? upcList;
  int? changedAt;
  int? changedSystem;

  PrimaryPackageListModel({
    this.id,
    this.tempPackId,
    this.packageName,
    this.printablePackageName,
    this.packageType,
    this.sellOrPurchase,
    this.packReferenceType,
    this.packageContentUomType,
    this.sizeId,
    this.packageContentQty,
    this.unitCost,
    this.weightedUnitCost,
    this.margin,
    this.markup,
    this.retailPrice,
    this.downBy,
    this.coldPrice,
    this.warmPrice,
    this.packageQty,
    this.qtyUpdateAction,
    this.upc,
    this.actionFlag,
    this.basePack,
    this.upcList,
    this.changedAt,
    this.changedSystem,
  });

  factory PrimaryPackageListModel.fromJson(Map<String, dynamic> json) => PrimaryPackageListModel(
        id: json["Id"],
        tempPackId: json["TempPackID"],
        packageName: json["PackageName"],
        printablePackageName: json["PrintablePackageName"],
        packageType: json["PackageType"],
        sellOrPurchase: json["SellOrPurchase"],
        packReferenceType: json["PackReferenceType"],
        packageContentUomType: json["PackageContentUOMType"],
        sizeId: json["SizeId"],
        packageContentQty: json["PackageContentQty"],
        unitCost: json["UnitCost"],
        weightedUnitCost: json["WeightedUnitCost"],
        margin: json["Margin"],
        markup: json["Markup"],
        retailPrice: json["RetailPrice"],
        downBy: json["DownBy"],
        coldPrice: json["ColdPrice"],
        warmPrice: json["WarmPrice"],
        packageQty: json["PackageQty"],
        qtyUpdateAction: json["QtyUpdateAction"],
        upc: json["UPC"],
        actionFlag: json["ActionFlag"],
        basePack: json["BasePack"],
        upcList: json["UPCList"] == null
            ? []
            : List<UpcList>.from(json["UPCList"]!.map((x) => UpcList.fromJson(x))),
        changedAt: json["ChangedAt"],
        changedSystem: json["ChangedSystem"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "TempPackID": tempPackId,
        "PackageName": packageName,
        "PrintablePackageName": printablePackageName,
        "PackageType": packageType,
        "SellOrPurchase": sellOrPurchase,
        "PackReferenceType": packReferenceType,
        "PackageContentUOMType": packageContentUomType,
        "SizeId": sizeId,
        "PackageContentQty": packageContentQty,
        "UnitCost": unitCost,
        "WeightedUnitCost": weightedUnitCost,
        "Margin": margin,
        "Markup": markup,
        "RetailPrice": retailPrice,
        "DownBy": downBy,
        "ColdPrice": coldPrice,
        "WarmPrice": warmPrice,
        "PackageQty": packageQty,
        "QtyUpdateAction": qtyUpdateAction,
        "UPC": upc,
        "ActionFlag": actionFlag,
        "BasePack": basePack,
        "UPCList": upcList == null ? [] : List<dynamic>.from(upcList!.map((x) => x.toJson())),
        "ChangedAt": changedAt,
        "ChangedSystem": changedSystem,
      };
}

class UpcList {
  String? id;
  String? upc;
  String? upcPoolId;
  bool? upcStatus;
  int? packReferenceType;
  String? packReferenceId;
  String? tempPackId;
  int? actionFlag;

  UpcList({
    this.id,
    this.upc,
    this.upcPoolId,
    this.upcStatus,
    this.packReferenceType,
    this.packReferenceId,
    this.tempPackId,
    this.actionFlag,
  });

  factory UpcList.fromJson(Map<String, dynamic> json) => UpcList(
        id: json["ID"],
        upc: json["UPC"],
        upcPoolId: json["UPCPoolID"],
        upcStatus: json["UPCStatus"],
        packReferenceType: json["PackReferenceType"],
        packReferenceId: json["PackReferenceID"],
        tempPackId: json["TempPackID"],
        actionFlag: json["ActionFlag"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "UPC": upc,
        "UPCPoolID": upcPoolId,
        "UPCStatus": upcStatus,
        "PackReferenceType": packReferenceType,
        "PackReferenceID": packReferenceId,
        "TempPackID": tempPackId,
        "ActionFlag": actionFlag,
      };
}

class StoreItemGeneralInfoModel {
  bool? openPrice;
  bool? nonRevenue;
  bool? nonReturn;
  bool? ebt;
  bool? wic;
  bool? deliplu;
  bool? inActive;
  bool? openQty;
  bool? nonDiscountable;
  bool? nonTransferable;
  bool? noCreditCard;
  bool? nonStocable;
  bool? sellBelowCost;
  int? itemAge;
  bool? packDialogShow;

  StoreItemGeneralInfoModel({
    this.openPrice,
    this.nonRevenue,
    this.nonReturn,
    this.ebt,
    this.wic,
    this.deliplu,
    this.inActive,
    this.openQty,
    this.nonDiscountable,
    this.nonTransferable,
    this.noCreditCard,
    this.nonStocable,
    this.sellBelowCost,
    this.itemAge,
    this.packDialogShow,
  });

  factory StoreItemGeneralInfoModel.fromJson(Map<String, dynamic> json) => StoreItemGeneralInfoModel(
        openPrice: json["OpenPrice"],
        nonRevenue: json["NonRevenue"],
        nonReturn: json["NonReturn"],
        ebt: json["Ebt"],
        wic: json["Wic"],
        deliplu: json["Deliplu"],
        inActive: json["InActive"],
        openQty: json["OpenQty"],
        nonDiscountable: json["NonDiscountable"],
        nonTransferable: json["NonTransferable"],
        noCreditCard: json["NoCreditCard"],
        nonStocable: json["NonStocable"],
        sellBelowCost: json["SellBelowCost"],
        itemAge: json["ItemAge"],
        packDialogShow: json["PackDialogShow"],
      );

  Map<String, dynamic> toJson() => {
        "OpenPrice": openPrice,
        "NonRevenue": nonRevenue,
        "NonReturn": nonReturn,
        "Ebt": ebt,
        "Wic": wic,
        "Deliplu": deliplu,
        "InActive": inActive,
        "OpenQty": openQty,
        "NonDiscountable": nonDiscountable,
        "NonTransferable": nonTransferable,
        "NoCreditCard": noCreditCard,
        "NonStocable": nonStocable,
        "SellBelowCost": sellBelowCost,
        "ItemAge": itemAge,
        "PackDialogShow": packDialogShow,
      };
}

class StoreItemModel {
  String? id;
  String? sku;
  String? skuPoolId;
  int? skuPoolType;
  String? name;
  String? itemId;
  String? itemTypeId;
  String? itemDeptId;
  String? itemCatId;
  String? itemSubCatId;
  String? scanDataId;
  bool? scanData;
  String? countryId;
  String? regionId;
  String? abbreviationId;
  String? flavourId;
  String? vintageId;
  String? familyId;
  String? ageId;
  String? notes;
  String? image;
  bool? syncLocally;
  String? supplierId;
  String? storeId;
  String? itemSelfLife;
  String? zoneId;
  String? generalInfoId;
  String? webInfoId;
  bool? nonTaxable;
  int? itemAge;
  int? uomType;
  bool? inActive;

  StoreItemModel({
    this.id,
    this.sku,
    this.skuPoolId,
    this.skuPoolType,
    this.name,
    this.itemId,
    this.itemTypeId,
    this.itemDeptId,
    this.itemCatId,
    this.itemSubCatId,
    this.scanDataId,
    this.scanData,
    this.countryId,
    this.regionId,
    this.abbreviationId,
    this.flavourId,
    this.vintageId,
    this.familyId,
    this.ageId,
    this.notes,
    this.image,
    this.syncLocally,
    this.supplierId,
    this.storeId,
    this.itemSelfLife,
    this.zoneId,
    this.generalInfoId,
    this.webInfoId,
    this.nonTaxable,
    this.itemAge,
    this.uomType,
    this.inActive,
  });

  factory StoreItemModel.fromJson(Map<String, dynamic> json) => StoreItemModel(
        id: json["ID"],
        sku: json["SKU"],
        skuPoolId: json["SKUPoolID"],
        skuPoolType: json["SKUPoolType"],
        name: json["Name"],
        itemId: json["ItemID"],
        itemTypeId: json["ItemTypeID"],
        itemDeptId: json["ItemDeptID"],
        itemCatId: json["ItemCatID"],
        itemSubCatId: json["ItemSubCatID"],
        scanDataId: json["ScanDataID"],
        scanData: json["ScanData"],
        countryId: json["CountryID"],
        regionId: json["RegionID"],
        abbreviationId: json["AbbreviationID"],
        flavourId: json["FlavourID"],
        vintageId: json["VintageID"],
        familyId: json["FamilyID"],
        ageId: json["AgeID"],
        notes: json["Notes"],
        image: json["Image"],
        syncLocally: json["SyncLocally"],
        supplierId: json["SupplierID"],
        storeId: json["StoreID"],
        itemSelfLife: json["ItemSelfLife"],
        zoneId: json["ZoneID"],
        generalInfoId: json["GeneralInfoID"],
        webInfoId: json["WebInfoID"],
        nonTaxable: json["NonTaxable"],
        itemAge: json["ItemAge"],
        uomType: json["UomType"],
        inActive: json["InActive"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "SKU": sku,
        "SKUPoolID": skuPoolId,
        "SKUPoolType": skuPoolType,
        "Name": name,
        "ItemID": itemId,
        "ItemTypeID": itemTypeId,
        "ItemDeptID": itemDeptId,
        "ItemCatID": itemCatId,
        "ItemSubCatID": itemSubCatId,
        "ScanDataID": scanDataId,
        "ScanData": scanData,
        "CountryID": countryId,
        "RegionID": regionId,
        "AbbreviationID": abbreviationId,
        "FlavourID": flavourId,
        "VintageID": vintageId,
        "FamilyID": familyId,
        "AgeID": ageId,
        "Notes": notes,
        "Image": image,
        "SyncLocally": syncLocally,
        "SupplierID": supplierId,
        "StoreID": storeId,
        "ItemSelfLife": itemSelfLife,
        "ZoneID": zoneId,
        "GeneralInfoID": generalInfoId,
        "WebInfoID": webInfoId,
        "NonTaxable": nonTaxable,
        "ItemAge": itemAge,
        "UomType": uomType,
        "InActive": inActive,
      };
}

class StoreItemPriceByQuantityListModel {
  String? id;
  int? qty;
  String? pricePerUnit;
  String? price;
  int? actionFlag;
  String? packageName;
  bool? packCheck;
  String? packReferenceId;
  String? tempPackId;
  int? packReferenceType;

  StoreItemPriceByQuantityListModel({
    this.id,
    this.qty,
    this.pricePerUnit,
    this.price,
    this.actionFlag,
    this.packageName,
    this.packCheck,
    this.packReferenceId,
    this.tempPackId,
    this.packReferenceType,
  });

  factory StoreItemPriceByQuantityListModel.fromJson(Map<String, dynamic> json) =>
      StoreItemPriceByQuantityListModel(
        id: json["ID"],
        qty: json["Qty"],
        pricePerUnit: json["PricePerUnit"],
        price: json["Price"],
        actionFlag: json["ActionFlag"],
        packageName: json["PackageName"],
        packCheck: json["PackCheck"],
        packReferenceId: json["PackReferenceID"],
        tempPackId: json["TempPackID"],
        packReferenceType: json["PackReferenceType"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Qty": qty,
        "PricePerUnit": pricePerUnit,
        "Price": price,
        "ActionFlag": actionFlag,
        "PackageName": packageName,
        "PackCheck": packCheck,
        "PackReferenceID": packReferenceId,
        "TempPackID": tempPackId,
        "PackReferenceType": packReferenceType,
      };
}

class StoreItemPriceLevelListModel {
  String? id;
  String? name;
  double? rate;
  String? rateType;
  int? type;
  bool? rateAdd;
  int? actionFlag;
  String? packageName;
  bool? packCheck;
  String? packReferenceId;
  String? tempPackId;
  int? packReferenceType;

  StoreItemPriceLevelListModel({
    this.id,
    this.name,
    this.rate,
    this.rateType,
    this.type,
    this.rateAdd,
    this.actionFlag,
    this.packageName,
    this.packCheck,
    this.packReferenceId,
    this.tempPackId,
    this.packReferenceType,
  });

  factory StoreItemPriceLevelListModel.fromJson(Map<String, dynamic> json) =>
      StoreItemPriceLevelListModel(
        id: json["ID"],
        name: json["Name"],
        rate: json["Rate"],
        rateType: json["RateType"],
        type: json["Type"],
        rateAdd: json["RateAdd"],
        actionFlag: json["ActionFlag"],
        packageName: json["PackageName"],
        packCheck: json["PackCheck"],
        packReferenceId: json["PackReferenceID"],
        tempPackId: json["TempPackID"],
        packReferenceType: json["PackReferenceType"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "Rate": rate,
        "RateType": rateType,
        "Type": type,
        "RateAdd": rateAdd,
        "ActionFlag": actionFlag,
        "PackageName": packageName,
        "PackCheck": packCheck,
        "PackReferenceID": packReferenceId,
        "TempPackID": tempPackId,
        "PackReferenceType": packReferenceType,
      };
}

class StoreItemWebInfoModel {
  String? name;
  int? price;
  String? note;
  String? description;
  List<dynamic>? webInfoImages;

  StoreItemWebInfoModel({
    this.name,
    this.price,
    this.note,
    this.description,
    this.webInfoImages,
  });

  factory StoreItemWebInfoModel.fromJson(Map<String, dynamic> json) => StoreItemWebInfoModel(
        name: json["Name"],
        price: json["Price"],
        note: json["Note"],
        description: json["Description"],
        webInfoImages: json["WebInfoImages"] == null
            ? []
            : List<dynamic>.from(json["WebInfoImages"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "Price": price,
        "Note": note,
        "Description": description,
        "WebInfoImages": webInfoImages == null ? [] : List<dynamic>.from(webInfoImages!.map((x) => x)),
      };
}

class TaxSlabListModel {
  String? id;
  String? taxSlabId;
  String? taxSlabName;
  int? actionFlag;

  TaxSlabListModel({
    this.id,
    this.taxSlabId,
    this.taxSlabName,
    this.actionFlag,
  });

  factory TaxSlabListModel.fromJson(Map<String, dynamic> json) => TaxSlabListModel(
        id: json["ID"],
        taxSlabId: json["TaxSlabID"],
        taxSlabName: json["TaxSlabName"],
        actionFlag: json["ActionFlag"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "TaxSlabID": taxSlabId,
        "TaxSlabName": taxSlabName,
        "ActionFlag": actionFlag,
      };
}

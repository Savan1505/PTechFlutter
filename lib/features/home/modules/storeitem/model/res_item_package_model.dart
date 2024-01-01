class ResItemPackageModel {
  bool? error;
  ItemPackageData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResItemPackageModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResItemPackageModel.fromJson(Map<String, dynamic> json) => ResItemPackageModel(
        error: json["Error"],
        data: json["Data"] == null ? null : ItemPackageData.fromJson(json["Data"]),
        code: json["Code"],
        message: json["Message"],
        timeStamp: json["TimeStamp"] == null ? null : DateTime.parse(json["TimeStamp"]),
      );

  Map<String, dynamic> toJson() => {
        "Error": error,
        "Data": data?.toJson(),
        "Code": code,
        "Message": message,
        "TimeStamp": timeStamp?.toIso8601String(),
      };
}

class ItemPackageData {
  StoreItemModel? storeItemModel;
  dynamic storeItemFlashSaleListModel;
  StoreItemGeneralInfoModel? storeItemGeneralInfoModel;
  dynamic storeItemLocationListModel;
  dynamic storeItemModifierListModel;
  List<StoreItemPriceLevelListModel>? storeItemPriceLevelListModel;
  dynamic storeItemDistributorListModel;
  StoreItemWebInfoModel? storeItemWebInfoModel;
  List<TaxSlabListModel>? taxSlabListModel;
  List<StoreItemPriceByQuantityListModel>? storeItemPriceByQuantityListModel;
  dynamic storeItemAlongListModel;
  List<PrimaryPackageListModel>? primaryPackageListModel;
  List<dynamic>? secondaryPackageListModel;
  List<dynamic>? tertiaryPackageListModel;
  dynamic storeItemVariantListModel;

  ItemPackageData({
    this.storeItemModel,
    this.storeItemFlashSaleListModel,
    this.storeItemGeneralInfoModel,
    this.storeItemLocationListModel,
    this.storeItemModifierListModel,
    this.storeItemPriceLevelListModel,
    this.storeItemDistributorListModel,
    this.storeItemWebInfoModel,
    this.taxSlabListModel,
    this.storeItemPriceByQuantityListModel,
    this.storeItemAlongListModel,
    this.primaryPackageListModel,
    this.secondaryPackageListModel,
    this.tertiaryPackageListModel,
    this.storeItemVariantListModel,
  });

  factory ItemPackageData.fromJson(Map<String, dynamic> json) => ItemPackageData(
        storeItemModel:
            json["StoreItemModel"] == null ? null : StoreItemModel.fromJson(json["StoreItemModel"]),
        storeItemFlashSaleListModel: json["StoreItemFlashSaleListModel"],
        storeItemGeneralInfoModel: json["StoreItemGeneralInfoModel"] == null
            ? null
            : StoreItemGeneralInfoModel.fromJson(json["StoreItemGeneralInfoModel"]),
        storeItemLocationListModel: json["StoreItemLocationListModel"],
        storeItemModifierListModel: json["StoreItemModifierListModel"],
        storeItemPriceLevelListModel: json["StoreItemPriceLevelListModel"] == null
            ? []
            : List<StoreItemPriceLevelListModel>.from(
                json["StoreItemPriceLevelListModel"]!
                    .map((x) => StoreItemPriceLevelListModel.fromJson(x)),
              ),
        storeItemDistributorListModel: json["StoreItemDistributorListModel"],
        storeItemWebInfoModel: json["StoreItemWebInfoModel"] == null
            ? null
            : StoreItemWebInfoModel.fromJson(json["StoreItemWebInfoModel"]),
        taxSlabListModel: json["TaxSlabListModel"] == null
            ? []
            : List<TaxSlabListModel>.from(
                json["TaxSlabListModel"]!.map((x) => TaxSlabListModel.fromJson(x)),
              ),
        storeItemPriceByQuantityListModel: json["StoreItemPriceByQuantityListModel"] == null
            ? []
            : List<StoreItemPriceByQuantityListModel>.from(
                json["StoreItemPriceByQuantityListModel"]!
                    .map((x) => StoreItemPriceByQuantityListModel.fromJson(x)),
              ),
        storeItemAlongListModel: json["StoreItemAlongListModel"],
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
        storeItemVariantListModel: json["StoreItemVariantListModel"],
      );

  Map<String, dynamic> toJson() => {
        "StoreItemModel": storeItemModel?.toJson(),
        "StoreItemFlashSaleListModel": storeItemFlashSaleListModel,
        "StoreItemGeneralInfoModel": storeItemGeneralInfoModel?.toJson(),
        "StoreItemLocationListModel": storeItemLocationListModel,
        "StoreItemModifierListModel": storeItemModifierListModel,
        "StoreItemPriceLevelListModel": storeItemPriceLevelListModel == null
            ? []
            : List<dynamic>.from(storeItemPriceLevelListModel!.map((x) => x.toJson())),
        "StoreItemDistributorListModel": storeItemDistributorListModel,
        "StoreItemWebInfoModel": storeItemWebInfoModel?.toJson(),
        "TaxSlabListModel":
            taxSlabListModel == null ? [] : List<dynamic>.from(taxSlabListModel!.map((x) => x.toJson())),
        "StoreItemPriceByQuantityListModel": storeItemPriceByQuantityListModel == null
            ? []
            : List<dynamic>.from(storeItemPriceByQuantityListModel!.map((x) => x.toJson())),
        "StoreItemAlongListModel": storeItemAlongListModel,
        "PrimaryPackageListModel": primaryPackageListModel == null
            ? []
            : List<dynamic>.from(primaryPackageListModel!.map((x) => x.toJson())),
        "SecondaryPackageListModel": secondaryPackageListModel == null
            ? []
            : List<dynamic>.from(secondaryPackageListModel!.map((x) => x)),
        "TertiaryPackageListModel": tertiaryPackageListModel == null
            ? []
            : List<dynamic>.from(tertiaryPackageListModel!.map((x) => x)),
        "StoreItemVariantListModel": storeItemVariantListModel,
      };
}

class PrimaryPackageListModel {
  String? id;
  String? storeItemId;
  String? tempPackId;
  String? packageName;
  int? packageType;
  int? sellOrPurchase;
  String? secondaryPackageId;
  int? packageContentUomType;
  double? packageContentQty;
  double? packageQty;
  double? unitCost;
  dynamic buyDown;
  double? markup;
  double? margin;
  double? retailPrice;
  double? coldPrice;
  double? warmPrice;
  double? weightedUnitCost;
  String? sizeId;
  bool? basePack;
  int? changedAt;
  int? changedSystem;
  List<UpcList>? upcList;
  int? qtyUpdateAction;
  int? actionFlag;

  PrimaryPackageListModel({
    this.id,
    this.storeItemId,
    this.tempPackId,
    this.packageName,
    this.packageType,
    this.sellOrPurchase,
    this.secondaryPackageId,
    this.packageContentUomType,
    this.packageContentQty,
    this.packageQty,
    this.unitCost,
    this.buyDown,
    this.markup,
    this.margin,
    this.retailPrice,
    this.coldPrice,
    this.warmPrice,
    this.weightedUnitCost,
    this.sizeId,
    this.basePack,
    this.changedAt,
    this.changedSystem,
    this.upcList,
    this.qtyUpdateAction,
    this.actionFlag,
  });

  factory PrimaryPackageListModel.fromJson(Map<String, dynamic> json) => PrimaryPackageListModel(
        id: json["Id"],
        storeItemId: json["StoreItemID"],
        tempPackId: json["TempPackID"],
        packageName: json["PackageName"],
        packageType: json["PackageType"],
        sellOrPurchase: json["SellOrPurchase"],
        secondaryPackageId: json["SecondaryPackageID"],
        packageContentUomType: json["PackageContentUOMType"],
        packageContentQty: json["PackageContentQty"],
        packageQty: json["PackageQty"],
        unitCost: json["UnitCost"],
        buyDown: json["BuyDown"],
        markup: json["Markup"]?.toDouble(),
        margin: json["Margin"]?.toDouble(),
        retailPrice: json["RetailPrice"],
        coldPrice: json["ColdPrice"],
        warmPrice: json["WarmPrice"],
        weightedUnitCost: json["WeightedUnitCost"],
        sizeId: json["SizeID"],
        basePack: json["BasePack"],
        changedAt: json["ChangedAt"],
        changedSystem: json["ChangedSystem"],
        upcList: json["UPCList"] == null
            ? []
            : List<UpcList>.from(json["UPCList"]!.map((x) => UpcList.fromJson(x))),
        qtyUpdateAction: json["QtyUpdateAction"],
        actionFlag: json["ActionFlag"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "StoreItemID": storeItemId,
        "TempPackID": tempPackId,
        "PackageName": packageName,
        "PackageType": packageType,
        "SellOrPurchase": sellOrPurchase,
        "SecondaryPackageID": secondaryPackageId,
        "PackageContentUOMType": packageContentUomType,
        "PackageContentQty": packageContentQty,
        "PackageQty": packageQty,
        "UnitCost": unitCost,
        "BuyDown": buyDown,
        "Markup": markup,
        "Margin": margin,
        "RetailPrice": retailPrice,
        "ColdPrice": coldPrice,
        "WarmPrice": warmPrice,
        "WeightedUnitCost": weightedUnitCost,
        "SizeID": sizeId,
        "BasePack": basePack,
        "ChangedAt": changedAt,
        "ChangedSystem": changedSystem,
        "UPCList": upcList == null ? [] : List<dynamic>.from(upcList!.map((x) => x.toJson())),
        "QtyUpdateAction": qtyUpdateAction,
        "ActionFlag": actionFlag,
      };
}

class UpcList {
  String? id;
  String? storeItemId;
  String? upc;
  bool? main;
  String? packReferenceId;
  String? tempPackId;
  String? upcPoolId;
  dynamic upcPoolType;
  int? packReferenceType;
  int? actionFlag;

  UpcList({
    this.id,
    this.storeItemId,
    this.upc,
    this.main,
    this.packReferenceId,
    this.tempPackId,
    this.upcPoolId,
    this.upcPoolType,
    this.packReferenceType,
    this.actionFlag,
  });

  factory UpcList.fromJson(Map<String, dynamic> json) => UpcList(
        id: json["Id"],
        storeItemId: json["StoreItemID"],
        upc: json["UPC"],
        main: json["Main"],
        packReferenceId: json["PackReferenceID"],
        tempPackId: json["TempPackID"],
        upcPoolId: json["UPCPoolID"],
        upcPoolType: json["UPCPoolType"],
        packReferenceType: json["PackReferenceType"],
        actionFlag: json["ActionFlag"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "StoreItemID": storeItemId,
        "UPC": upc,
        "Main": main,
        "PackReferenceID": packReferenceId,
        "TempPackID": tempPackId,
        "UPCPoolID": upcPoolId,
        "UPCPoolType": upcPoolType,
        "PackReferenceType": packReferenceType,
        "ActionFlag": actionFlag,
      };
}

class StoreItemGeneralInfoModel {
  String? id;
  bool? openPrice;
  bool? nonRevenue;
  bool? nonReturn;
  bool? ebt;
  bool? wic;
  bool? deliplu;
  bool? openQty;
  bool? nonDiscountable;
  bool? nonTransferable;
  bool? noCreditCard;
  bool? nonStocable;
  double? rewardsPoints;
  String? itemAge;
  bool? packDialogShow;

  StoreItemGeneralInfoModel({
    this.id,
    this.openPrice,
    this.nonRevenue,
    this.nonReturn,
    this.ebt,
    this.wic,
    this.deliplu,
    this.openQty,
    this.nonDiscountable,
    this.nonTransferable,
    this.noCreditCard,
    this.nonStocable,
    this.rewardsPoints,
    this.itemAge,
    this.packDialogShow,
  });

  factory StoreItemGeneralInfoModel.fromJson(Map<String, dynamic> json) => StoreItemGeneralInfoModel(
        id: json["Id"],
        openPrice: json["OpenPrice"],
        nonRevenue: json["NonRevenue"],
        nonReturn: json["NonReturn"],
        ebt: json["Ebt"],
        wic: json["Wic"],
        deliplu: json["Deliplu"],
        openQty: json["OpenQty"],
        nonDiscountable: json["NonDiscountable"],
        nonTransferable: json["NonTransferable"],
        noCreditCard: json["NoCreditCard"],
        nonStocable: json["NonStocable"],
        rewardsPoints: json["RewardsPoints"],
        itemAge: json["ItemAge"],
        packDialogShow: json["PackDialogShow"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "OpenPrice": openPrice,
        "NonRevenue": nonRevenue,
        "NonReturn": nonReturn,
        "Ebt": ebt,
        "Wic": wic,
        "Deliplu": deliplu,
        "OpenQty": openQty,
        "NonDiscountable": nonDiscountable,
        "NonTransferable": nonTransferable,
        "NoCreditCard": noCreditCard,
        "NonStocable": nonStocable,
        "RewardsPoints": rewardsPoints,
        "ItemAge": itemAge,
        "PackDialogShow": packDialogShow,
      };
}

class StoreItemModel {
  String? id;
  String? name;
  String? image;
  String? scanDataId;
  bool? scanData;
  dynamic countryId;
  String? abbreviationId;
  String? ageId;
  bool? syncLocally;
  String? itemId;
  String? storeId;
  String? zoneId;
  String? regionId;
  String? flavourId;
  String? vintageId;
  String? familyId;
  String? itemDeptId;
  dynamic printedLabelId;
  dynamic digitalLabelId;
  String? generalInfoId;
  String? supplierId;
  String? webInfoId;
  bool? inActive;
  bool? nonTaxable;
  String? itemCatId;
  String? itemSubCatId;
  String? itemTypeId;
  String? sku;
  int? skuPoolType;
  String? skuPoolId;
  int? uomType;
  bool? allowMtoSFlag;
  dynamic groupId;

  StoreItemModel({
    this.id,
    this.name,
    this.image,
    this.scanDataId,
    this.scanData,
    this.countryId,
    this.abbreviationId,
    this.ageId,
    this.syncLocally,
    this.itemId,
    this.storeId,
    this.zoneId,
    this.regionId,
    this.flavourId,
    this.vintageId,
    this.familyId,
    this.itemDeptId,
    this.printedLabelId,
    this.digitalLabelId,
    this.generalInfoId,
    this.supplierId,
    this.webInfoId,
    this.inActive,
    this.nonTaxable,
    this.itemCatId,
    this.itemSubCatId,
    this.itemTypeId,
    this.sku,
    this.skuPoolType,
    this.skuPoolId,
    this.uomType,
    this.allowMtoSFlag,
    this.groupId,
  });

  factory StoreItemModel.fromJson(Map<String, dynamic> json) => StoreItemModel(
        id: json["Id"],
        name: json["Name"],
        image: json["Image"],
        scanDataId: json["ScanDataID"],
        scanData: json["ScanData"],
        countryId: json["CountryID"],
        abbreviationId: json["AbbreviationID"],
        ageId: json["AgeID"],
        syncLocally: json["SyncLocally"],
        itemId: json["ItemID"],
        storeId: json["StoreID"],
        zoneId: json["ZoneID"],
        regionId: json["RegionID"],
        flavourId: json["FlavourID"],
        vintageId: json["VintageID"],
        familyId: json["FamilyID"],
        itemDeptId: json["ItemDeptID"],
        printedLabelId: json["PrintedLabelID"],
        digitalLabelId: json["DigitalLabelID"],
        generalInfoId: json["GeneralInfoID"],
        supplierId: json["SupplierID"],
        webInfoId: json["WebInfoID"],
        inActive: json["InActive"],
        nonTaxable: json["NonTaxable"],
        itemCatId: json["ItemCatID"],
        itemSubCatId: json["ItemSubCatID"],
        itemTypeId: json["ItemTypeID"],
        sku: json["SKU"],
        skuPoolType: json["SKUPoolType"],
        skuPoolId: json["SKUPoolID"],
        uomType: json["UomType"],
        allowMtoSFlag: json["AllowMtoSFlag"],
        groupId: json["GroupID"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "Image": image,
        "ScanDataID": scanDataId,
        "ScanData": scanData,
        "CountryID": countryId,
        "AbbreviationID": abbreviationId,
        "AgeID": ageId,
        "SyncLocally": syncLocally,
        "ItemID": itemId,
        "StoreID": storeId,
        "ZoneID": zoneId,
        "RegionID": regionId,
        "FlavourID": flavourId,
        "VintageID": vintageId,
        "FamilyID": familyId,
        "ItemDeptID": itemDeptId,
        "PrintedLabelID": printedLabelId,
        "DigitalLabelID": digitalLabelId,
        "GeneralInfoID": generalInfoId,
        "SupplierID": supplierId,
        "WebInfoID": webInfoId,
        "InActive": inActive,
        "NonTaxable": nonTaxable,
        "ItemCatID": itemCatId,
        "ItemSubCatID": itemSubCatId,
        "ItemTypeID": itemTypeId,
        "SKU": sku,
        "SKUPoolType": skuPoolType,
        "SKUPoolID": skuPoolId,
        "UomType": uomType,
        "AllowMtoSFlag": allowMtoSFlag,
        "GroupID": groupId,
      };
}

class StoreItemPriceByQuantityListModel {
  String? id;
  String? storeItemId;
  int? qty;
  double? pricePerUnit;
  String? packReferenceId;
  String? tempPackId;
  int? packReferenceType;
  int? actionFlag;

  StoreItemPriceByQuantityListModel({
    this.id,
    this.storeItemId,
    this.qty,
    this.pricePerUnit,
    this.packReferenceId,
    this.tempPackId,
    this.packReferenceType,
    this.actionFlag,
  });

  factory StoreItemPriceByQuantityListModel.fromJson(Map<String, dynamic> json) =>
      StoreItemPriceByQuantityListModel(
        id: json["Id"],
        storeItemId: json["StoreItemID"],
        qty: json["Qty"],
        pricePerUnit: json["PricePerUnit"],
        packReferenceId: json["PackReferenceID"],
        tempPackId: json["TempPackID"],
        packReferenceType: json["PackReferenceType"],
        actionFlag: json["ActionFlag"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "StoreItemID": storeItemId,
        "Qty": qty,
        "PricePerUnit": pricePerUnit,
        "PackReferenceID": packReferenceId,
        "TempPackID": tempPackId,
        "PackReferenceType": packReferenceType,
        "ActionFlag": actionFlag,
      };
}

class StoreItemPriceLevelListModel {
  String? id;
  String? name;
  double? rate;
  int? type;
  int? rateType;
  String? referenceId;
  bool? rateAdd;
  String? packReferenceId;
  String? tempPackId;
  int? packReferenceType;
  int? actionFlag;

  StoreItemPriceLevelListModel({
    this.id,
    this.name,
    this.rate,
    this.type,
    this.rateType,
    this.referenceId,
    this.rateAdd,
    this.packReferenceId,
    this.tempPackId,
    this.packReferenceType,
    this.actionFlag,
  });

  factory StoreItemPriceLevelListModel.fromJson(Map<String, dynamic> json) =>
      StoreItemPriceLevelListModel(
        id: json["Id"],
        name: json["Name"],
        rate: json["Rate"],
        type: json["Type"],
        rateType: json["RateType"],
        referenceId: json["RefrenceID"],
        rateAdd: json["RateAdd"],
        packReferenceId: json["PackReferenceID"],
        tempPackId: json["TempPackID"],
        packReferenceType: json["PackReferenceType"],
        actionFlag: json["ActionFlag"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "Rate": rate,
        "Type": type,
        "RateType": rateType,
        "RefrenceID": referenceId,
        "RateAdd": rateAdd,
        "PackReferenceID": packReferenceId,
        "TempPackID": tempPackId,
        "PackReferenceType": packReferenceType,
        "ActionFlag": actionFlag,
      };
}

class StoreItemWebInfoModel {
  dynamic id;
  String? description;
  String? name;
  double? price;
  String? note;
  List<dynamic>? webInfoImages;

  StoreItemWebInfoModel({
    this.id,
    this.description,
    this.name,
    this.price,
    this.note,
    this.webInfoImages,
  });

  factory StoreItemWebInfoModel.fromJson(Map<String, dynamic> json) => StoreItemWebInfoModel(
        id: json["Id"],
        description: json["Description"],
        name: json["Name"],
        price: json["Price"],
        note: json["Note"],
        webInfoImages: json["WebInfoImages"] == null
            ? []
            : List<dynamic>.from(json["WebInfoImages"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Description": description,
        "Name": name,
        "Price": price,
        "Note": note,
        "WebInfoImages": webInfoImages == null ? [] : List<dynamic>.from(webInfoImages!.map((x) => x)),
      };
}

class TaxSlabListModel {
  String? id;
  String? storeItemId;
  String? taxSlabId;
  int? actionFlag;

  TaxSlabListModel({
    this.id,
    this.storeItemId,
    this.taxSlabId,
    this.actionFlag,
  });

  factory TaxSlabListModel.fromJson(Map<String, dynamic> json) => TaxSlabListModel(
        id: json["Id"],
        storeItemId: json["StoreItemID"],
        taxSlabId: json["TaxSlabID"],
        actionFlag: json["ActionFlag"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "StoreItemID": storeItemId,
        "TaxSlabID": taxSlabId,
        "ActionFlag": actionFlag,
      };
}

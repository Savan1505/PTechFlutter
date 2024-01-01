class ReqItemTaxLabModel {
  String? name;
  String? description;
  double? taxSlab;
  List<String>? storeIdList;

  ReqItemTaxLabModel({
    this.name,
    this.description,
    this.taxSlab,
    this.storeIdList,
  });

  factory ReqItemTaxLabModel.fromJson(Map<String, dynamic> json) => ReqItemTaxLabModel(
        name: json["Name"],
        description: json["Description"],
        taxSlab: json["TaxSlab"],
        storeIdList:
            json["StoreIdList"] == null ? [] : List<String>.from(json["StoreIdList"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "Description": description,
        "TaxSlab": taxSlab,
        "StoreIdList": storeIdList == null ? [] : List<dynamic>.from(storeIdList!.map((x) => x)),
      };
}

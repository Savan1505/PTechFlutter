class ReqQuickAccessGroupModel {
  String? name;
  String? description;
  bool? favorite;
  bool? show;
  List<String>? storeIdList;
  List<StoreItemIdList>? storeItemIdList;

  ReqQuickAccessGroupModel({
    this.name,
    this.description,
    this.favorite,
    this.show,
    this.storeIdList,
    this.storeItemIdList,
  });

  factory ReqQuickAccessGroupModel.fromJson(Map<String, dynamic> json) => ReqQuickAccessGroupModel(
        name: json["Name"],
        description: json["Description"],
        favorite: json["Favorite"],
        show: json["Show"],
        storeIdList:
            json["StoreIDList"] == null ? [] : List<String>.from(json["StoreIDList"]!.map((x) => x)),
        storeItemIdList: json["StoreItemIDList"] == null
            ? []
            : List<StoreItemIdList>.from(
                json["StoreItemIDList"]!.map((x) => StoreItemIdList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "Description": description,
        "Favorite": favorite,
        "Show": show,
        "StoreIDList": storeIdList == null ? [] : List<dynamic>.from(storeIdList!.map((x) => x)),
        "StoreItemIDList":
            storeItemIdList == null ? [] : List<dynamic>.from(storeItemIdList!.map((x) => x.toJson())),
      };
}

class StoreItemIdList {
  int? actionFlag;
  String? storeItemId;
  String? name;

  StoreItemIdList({
    this.actionFlag,
    this.storeItemId,
    this.name,
  });

  factory StoreItemIdList.fromJson(Map<String, dynamic> json) => StoreItemIdList(
        actionFlag: json["ActionFlag"],
        storeItemId: json["StoreItemID"],
        name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "ActionFlag": actionFlag,
        "StoreItemID": storeItemId,
        "Name": name,
      };
}

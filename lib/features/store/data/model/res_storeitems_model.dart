class StoreItemModel {
  int? count;
  List<StoreListElement>? listStoreElement;

  StoreItemModel({
    this.count,
    this.listStoreElement,
  });

  factory StoreItemModel.fromJson(Map<String, dynamic> json) => StoreItemModel(
        count: json["Count"],
        listStoreElement: json["List"] == null
            ? []
            : List<StoreListElement>.from(json["List"]!.map((x) => StoreListElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Count": count,
        "List":
            listStoreElement == null ? [] : List<dynamic>.from(listStoreElement!.map((x) => x.toJson())),
      };
}

class StoreListElement {
  String? firstName;
  String? lastName;
  dynamic middleName;
  String? primaryMobile;
  String? primaryEmail;
  String? zoneName;
  String? countryName;
  String? stateName;
  String? cityName;
  String? estDate;
  String? individualId;
  String? logo;
  List<Marketplace>? marketplaces;
  String? id;
  String? name;
  String? inStoreTimezone;
  String? dayEndTime;

  StoreListElement({
    this.firstName,
    this.lastName,
    this.middleName,
    this.primaryMobile,
    this.primaryEmail,
    this.zoneName,
    this.countryName,
    this.stateName,
    this.cityName,
    this.estDate,
    this.individualId,
    this.logo,
    this.marketplaces,
    this.id,
    this.name,
    this.inStoreTimezone,
    this.dayEndTime,
  });

  factory StoreListElement.fromJson(Map<String, dynamic> json) => StoreListElement(
        firstName: json["FirstName"],
        lastName: json["LastName"],
        middleName: json["MiddleName"],
        primaryMobile: json["PrimaryMobile"],
        primaryEmail: json["PrimaryEmail"],
        zoneName: json["ZoneName"],
        countryName: json["CountryName"],
        stateName: json["StateName"],
        cityName: json["CityName"],
        estDate: json["EstDate"],
        individualId: json["IndividualID"],
        logo: json["Logo"],
        marketplaces: json["Marketplaces"] == null
            ? []
            : List<Marketplace>.from(json["Marketplaces"]!.map((x) => Marketplace.fromJson(x))),
        id: json["ID"],
        name: json["Name"],
        inStoreTimezone: json["InStoreTimezone"],
        dayEndTime: json["DayEndTime"],
      );

  Map<String, dynamic> toJson() => {
        "FirstName": firstName,
        "LastName": lastName,
        "MiddleName": middleName,
        "PrimaryMobile": primaryMobile,
        "PrimaryEmail": primaryEmail,
        "ZoneName": zoneName,
        "CountryName": countryName,
        "StateName": stateName,
        "CityName": cityName,
        "EstDate": estDate,
        "IndividualID": individualId,
        "Logo": logo,
        "Marketplaces":
            marketplaces == null ? [] : List<dynamic>.from(marketplaces!.map((x) => x.toJson())),
        "ID": id,
        "Name": name,
        "InStoreTimezone": inStoreTimezone,
        "DayEndTime": dayEndTime,
      };
}

class Marketplace {
  String? id;
  String? name;
  bool? locked;

  Marketplace({
    this.id,
    this.name,
    this.locked,
  });

  factory Marketplace.fromJson(Map<String, dynamic> json) => Marketplace(
        id: json["ID"],
        name: json["Name"],
        locked: json["Locked"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "Locked": locked,
      };
}

class ResDistributorModel {
  bool? error;
  DistributorData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResDistributorModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResDistributorModel.fromJson(Map<String, dynamic> json) => ResDistributorModel(
        error: json["Error"],
        data: json["Data"] == null ? null : DistributorData.fromJson(json["Data"]),
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

class DistributorData {
  int? count;
  List<Distributor>? list;

  DistributorData({
    this.count,
    this.list,
  });

  factory DistributorData.fromJson(Map<String, dynamic> json) => DistributorData(
        count: json["Count"],
        list: json["List"] == null
            ? []
            : List<Distributor>.from(json["List"]!.map((x) => Distributor.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Count": count,
        "List": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class Distributor {
  String? id;
  String? companyName;
  String? code;
  int? paymentTerms;
  String? individualId;
  String? firstName;
  String? lastName;
  String? primaryMobile;
  String? secondaryMobile;
  String? primaryEmail;
  String? name;

  Distributor({
    this.id,
    this.companyName,
    this.code,
    this.paymentTerms,
    this.individualId,
    this.firstName,
    this.lastName,
    this.primaryMobile,
    this.secondaryMobile,
    this.primaryEmail,
    this.name,
  });

  factory Distributor.fromJson(Map<String, dynamic> json) => Distributor(
        id: json["ID"],
        companyName: json["CompanyName"],
        code: json["Code"],
        paymentTerms: json["PaymentTerms"],
        individualId: json["IndividualID"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
        primaryMobile: json["PrimaryMobile"],
        secondaryMobile: json["SecondaryMobile"],
        primaryEmail: json["PrimaryEmail"],
        name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "CompanyName": companyName,
        "Code": code,
        "PaymentTerms": paymentTerms,
        "IndividualID": individualId,
        "FirstName": firstName,
        "LastName": lastName,
        "PrimaryMobile": primaryMobile,
        "SecondaryMobile": secondaryMobile,
        "PrimaryEmail": primaryEmail,
        "Name": name,
      };
}

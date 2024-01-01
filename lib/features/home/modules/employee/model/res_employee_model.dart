class ResEmployeeModel {
  bool? error;
  EmployeeData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResEmployeeModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResEmployeeModel.fromJson(Map<String, dynamic> json) => ResEmployeeModel(
        error: json["Error"],
        data: json["Data"] == null ? null : EmployeeData.fromJson(json["Data"]),
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

class EmployeeData {
  int? count;
  List<Employee>? list;

  EmployeeData({
    this.count,
    this.list,
  });

  factory EmployeeData.fromJson(Map<String, dynamic> json) => EmployeeData(
        count: json["Count"],
        list: json["List"] == null
            ? []
            : List<Employee>.from(json["List"]!.map((x) => Employee.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Count": count,
        "List": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class Employee {
  String? id;
  String? storeId;
  String? individualId;
  String? storeRoleId;
  String? firstName;
  String? lastName;
  String? bloodGroup;
  DateTime? dob;
  String? primaryMobile;
  String? secondaryMobile;
  String? primaryEmail;
  String? secondaryEmail;
  String? street1;
  String? street2;
  String? city;
  String? state;
  String? country;
  String? pinCode;
  int? addressType;
  String? image;
  DateTime? joinDate;
  int? payroleType;
  double? payroleAmount;
  bool? webUser;
  bool? posUser;
  String? additionalData;
  String? addressId;
  String? area;
  int? gender;
  String? storeRoleName;
  dynamic storeKey;
  bool? active;
  String? inStoreTimezone;
  bool? deActivated;
  dynamic deActivatedOn;
  bool? webUserNeeded;
  bool? posUserNeeded;
  bool? isWebUserExist;
  bool? skipShiftModule;

  Employee({
    this.id,
    this.storeId,
    this.individualId,
    this.storeRoleId,
    this.firstName,
    this.lastName,
    this.bloodGroup,
    this.dob,
    this.primaryMobile,
    this.secondaryMobile,
    this.primaryEmail,
    this.secondaryEmail,
    this.street1,
    this.street2,
    this.city,
    this.state,
    this.country,
    this.pinCode,
    this.addressType,
    this.image,
    this.joinDate,
    this.payroleType,
    this.payroleAmount,
    this.webUser,
    this.posUser,
    this.additionalData,
    this.addressId,
    this.area,
    this.gender,
    this.storeRoleName,
    this.storeKey,
    this.active,
    this.inStoreTimezone,
    this.deActivated,
    this.deActivatedOn,
    this.webUserNeeded,
    this.posUserNeeded,
    this.isWebUserExist,
    this.skipShiftModule,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        id: json["ID"],
        storeId: json["StoreID"],
        individualId: json["IndividualID"],
        storeRoleId: json["StoreRoleID"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
        bloodGroup: json["BloodGroup"],
        dob: json["Dob"] == null ? null : DateTime.parse(json["Dob"]),
        primaryMobile: json["PrimaryMobile"],
        secondaryMobile: json["SecondaryMobile"],
        primaryEmail: json["PrimaryEmail"],
        secondaryEmail: json["SecondaryEmail"],
        street1: json["Street1"],
        street2: json["Street2"],
        city: json["City"],
        state: json["State"],
        country: json["Country"],
        pinCode: json["PinCode"],
        addressType: json["AddressType"],
        image: json["Image"],
        joinDate: json["JoinDate"] == null ? null : DateTime.parse(json["JoinDate"]),
        payroleType: json["PayroleType"],
        payroleAmount: json["PayroleAmount"],
        webUser: json["WebUser"],
        posUser: json["PosUser"],
        additionalData: json["AdditionalData"],
        addressId: json["AddressID"],
        area: json["Area"],
        gender: json["Gender"],
        storeRoleName: json["StoreRoleName"],
        storeKey: json["StoreKey"],
        active: json["Active"],
        inStoreTimezone: json["InStoreTimezone"],
        deActivated: json["DeActivated"],
        deActivatedOn: json["DeActivatedOn"],
        webUserNeeded: json["WebUserNeeded"],
        posUserNeeded: json["PosUserNeeded"],
        isWebUserExist: json["IsWebUserExist"],
        skipShiftModule: json["SkipShiftModule"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "StoreID": storeId,
        "IndividualID": individualId,
        "StoreRoleID": storeRoleId,
        "FirstName": firstName,
        "LastName": lastName,
        "BloodGroup": bloodGroup,
        "Dob": dob?.toIso8601String(),
        "PrimaryMobile": primaryMobile,
        "SecondaryMobile": secondaryMobile,
        "PrimaryEmail": primaryEmail,
        "SecondaryEmail": secondaryEmail,
        "Street1": street1,
        "Street2": street2,
        "City": city,
        "State": state,
        "Country": country,
        "PinCode": pinCode,
        "AddressType": addressType,
        "Image": image,
        "JoinDate": joinDate?.toIso8601String(),
        "PayroleType": payroleType,
        "PayroleAmount": payroleAmount,
        "WebUser": webUser,
        "PosUser": posUser,
        "AdditionalData": additionalData,
        "AddressID": addressId,
        "Area": area,
        "Gender": gender,
        "StoreRoleName": storeRoleName,
        "StoreKey": storeKey,
        "Active": active,
        "InStoreTimezone": inStoreTimezone,
        "DeActivated": deActivated,
        "DeActivatedOn": deActivatedOn,
        "WebUserNeeded": webUserNeeded,
        "PosUserNeeded": posUserNeeded,
        "IsWebUserExist": isWebUserExist,
        "SkipShiftModule": skipShiftModule,
      };
}

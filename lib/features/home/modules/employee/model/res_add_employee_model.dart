class ResAddEmployeeModel {
  bool? error;
  AddEmployeeData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResAddEmployeeModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResAddEmployeeModel.fromJson(Map<String, dynamic> json) => ResAddEmployeeModel(
        error: json["Error"],
        data: json["Data"] == null ? null : AddEmployeeData.fromJson(json["Data"]),
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

class AddEmployeeData {
  String? id;
  String? pinHash;
  dynamic authUserId;
  String? individualId;
  String? storeId;
  DateTime? joinDate;
  int? payroleType;
  double? payroleAmount;
  bool? webUser;
  bool? posUser;
  String? image;
  dynamic deActivatedOn;
  bool? deActivated;
  String? storeRoleId;
  String? additionalData;
  String? firstName;
  String? lastName;
  String? primaryMobile;
  String? secondaryMobile;
  String? primaryEmail;
  String? secondaryEmail;
  DateTime? dob;
  int? gender;
  String? bloodGroup;
  String? language;
  String? addressId;
  String? street1;
  String? street2;
  String? landmark;
  String? area;
  String? city;
  String? state;
  String? country;
  String? pinCode;
  dynamic roleName;
  String? userName;
  String? password;

  AddEmployeeData({
    this.id,
    this.pinHash,
    this.authUserId,
    this.individualId,
    this.storeId,
    this.joinDate,
    this.payroleType,
    this.payroleAmount,
    this.webUser,
    this.posUser,
    this.image,
    this.deActivatedOn,
    this.deActivated,
    this.storeRoleId,
    this.additionalData,
    this.firstName,
    this.lastName,
    this.primaryMobile,
    this.secondaryMobile,
    this.primaryEmail,
    this.secondaryEmail,
    this.dob,
    this.gender,
    this.bloodGroup,
    this.language,
    this.addressId,
    this.street1,
    this.street2,
    this.landmark,
    this.area,
    this.city,
    this.state,
    this.country,
    this.pinCode,
    this.roleName,
    this.userName,
    this.password,
  });

  factory AddEmployeeData.fromJson(Map<String, dynamic> json) => AddEmployeeData(
        id: json["ID"],
        pinHash: json["PinHash"],
        authUserId: json["AuthUserID"],
        individualId: json["IndividualID"],
        storeId: json["StoreID"],
        joinDate: json["JoinDate"] == null ? null : DateTime.parse(json["JoinDate"]),
        payroleType: json["PayroleType"],
        payroleAmount: json["PayroleAmount"],
        webUser: json["WebUser"],
        posUser: json["PosUser"],
        image: json["Image"],
        deActivatedOn: json["DeActivatedOn"],
        deActivated: json["DeActivated"],
        storeRoleId: json["StoreRoleID"],
        additionalData: json["AdditionalData"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
        primaryMobile: json["PrimaryMobile"],
        secondaryMobile: json["SecondaryMobile"],
        primaryEmail: json["PrimaryEmail"],
        secondaryEmail: json["SecondaryEmail"],
        dob: json["DOB"] == null ? null : DateTime.parse(json["DOB"]),
        gender: json["Gender"],
        bloodGroup: json["BloodGroup"],
        language: json["Language"],
        addressId: json["AddressID"],
        street1: json["Street1"],
        street2: json["Street2"],
        landmark: json["Landmark"],
        area: json["Area"],
        city: json["City"],
        state: json["State"],
        country: json["Country"],
        pinCode: json["PinCode"],
        roleName: json["RoleName"],
        userName: json["UserName"],
        password: json["Password"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "PinHash": pinHash,
        "AuthUserID": authUserId,
        "IndividualID": individualId,
        "StoreID": storeId,
        "JoinDate": joinDate?.toIso8601String(),
        "PayroleType": payroleType,
        "PayroleAmount": payroleAmount,
        "WebUser": webUser,
        "PosUser": posUser,
        "Image": image,
        "DeActivatedOn": deActivatedOn,
        "DeActivated": deActivated,
        "StoreRoleID": storeRoleId,
        "AdditionalData": additionalData,
        "FirstName": firstName,
        "LastName": lastName,
        "PrimaryMobile": primaryMobile,
        "SecondaryMobile": secondaryMobile,
        "PrimaryEmail": primaryEmail,
        "SecondaryEmail": secondaryEmail,
        "DOB": dob?.toIso8601String(),
        "Gender": gender,
        "BloodGroup": bloodGroup,
        "Language": language,
        "AddressID": addressId,
        "Street1": street1,
        "Street2": street2,
        "Landmark": landmark,
        "Area": area,
        "City": city,
        "State": state,
        "Country": country,
        "PinCode": pinCode,
        "RoleName": roleName,
        "UserName": userName,
        "Password": password,
      };
}

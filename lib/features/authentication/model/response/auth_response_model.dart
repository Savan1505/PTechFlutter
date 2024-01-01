import 'dart:convert';

class AuthResponseModel {
  int? count;
  List<ProfileListModel>? list;

  AuthResponseModel({
    this.count,
    this.list,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      AuthResponseModel(
        count: json["Count"],
        list: json["List"] == null
            ? []
            : List<ProfileListModel>.from(
                json["List"]!.map((x) => ProfileListModel.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "Count": count,
        "List": list == null
            ? []
            : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class ProfileListModel {
  ProfileModel? profileModel;
  List<PermissionList>? permissionList;

  ProfileListModel({
    this.profileModel,
    this.permissionList,
  });

  factory ProfileListModel.fromJson(Map<String, dynamic> json) =>
      ProfileListModel(
        profileModel: json["ProfileModel"] == null
            ? null
            : ProfileModel.fromJson(json["ProfileModel"]),
        permissionList: json["PermissionList"] == null
            ? []
            : List<PermissionList>.from(
                json["PermissionList"]!.map((x) => PermissionList.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "ProfileModel": profileModel?.toJson(),
        "PermissionList": permissionList == null
            ? []
            : List<dynamic>.from(permissionList!.map((x) => x.toJson())),
      };
}

class PermissionList {
  String? id;
  String? name;
  String? permissionUuid;
  String? moduleId;
  String? permissionOption;

  PermissionList({
    this.id,
    this.name,
    this.permissionUuid,
    this.moduleId,
    this.permissionOption,
  });

  factory PermissionList.fromJson(Map<String, dynamic> json) => PermissionList(
        id: json["ID"],
        name: json["Name"],
        permissionUuid: json["PermissionUUID"],
        moduleId: json["ModuleID"],
        permissionOption: json["PermissionOption"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "PermissionUUID": permissionUuid,
        "ModuleID": moduleId,
        "PermissionOption": permissionOption,
      };

  static List<PermissionList> decode(String permissionList) =>
      (json.decode(permissionList) as List<dynamic>)
          .map<PermissionList>((item) => PermissionList.fromJson(item))
          .toList();

  static String encode(List<PermissionList> permissionLists) => json.encode(
        permissionLists
            .map<Map<String, dynamic>>(
              (permissionList) => permissionList.toJson(),
            )
            .toList(),
      );
}

class ProfileModel {
  String? id;
  String? storeId;
  String? individualId;
  String? storeRoleId;
  String? firstName;
  String? lastName;
  dynamic bloodGroup;
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

  ProfileModel({
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
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
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
        joinDate:
            json["JoinDate"] == null ? null : DateTime.parse(json["JoinDate"]),
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
      };
}

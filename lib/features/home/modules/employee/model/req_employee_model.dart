class ReqEmployeeModel {
  String? id;
  dynamic authUserId;
  String? storeId;
  String? firstName;
  String? lastName;
  String? primaryMobile;
  String? primaryEmail;
  String? secondaryMobile;
  String? secondaryEmail;
  int? gender;
  String? storeRoleId;
  bool? webUser;
  bool? posUser;
  dynamic dob;
  String? bloodGroup;
  String? userName;
  String? password;
  String? confirmPassword;
  String? pin;
  String? pinHash;
  String? confirmPin;
  String? joinDate;
  int? payroleAmount;
  int? payroleType;
  String? language;
  String? street1;
  String? street2;
  String? landmark;
  String? area;
  String? pinCode;
  String? city;
  String? state;
  String? country;
  String? additionalData;
  String? addressId;
  String? image;

  ReqEmployeeModel({
    this.id,
    this.authUserId,
    this.storeId,
    this.firstName,
    this.lastName,
    this.primaryMobile,
    this.primaryEmail,
    this.secondaryMobile,
    this.secondaryEmail,
    this.gender,
    this.storeRoleId,
    this.webUser,
    this.posUser,
    this.dob,
    this.bloodGroup,
    this.userName,
    this.password,
    this.confirmPassword,
    this.pin,
    this.pinHash,
    this.confirmPin,
    this.joinDate,
    this.payroleAmount,
    this.payroleType,
    this.language,
    this.street1,
    this.street2,
    this.landmark,
    this.area,
    this.pinCode,
    this.city,
    this.state,
    this.country,
    this.additionalData,
    this.addressId,
    this.image,
  });

  factory ReqEmployeeModel.fromJson(Map<String, dynamic> json) => ReqEmployeeModel(
        id: json["ID"],
        authUserId: json["AuthUserID"],
        storeId: json["StoreID"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
        primaryMobile: json["PrimaryMobile"],
        primaryEmail: json["PrimaryEmail"],
        secondaryMobile: json["SecondaryMobile"],
        secondaryEmail: json["SecondaryEmail"],
        gender: json["Gender"],
        storeRoleId: json["StoreRoleID"],
        webUser: json["WebUser"],
        posUser: json["PosUser"],
        dob: json["DOB"],
        bloodGroup: json["BloodGroup"],
        userName: json["UserName"],
        password: json["Password"],
        confirmPassword: json["ConfirmPassword"],
        pin: json["Pin"],
        pinHash: json["PinHash"],
        confirmPin: json["ConfirmPin"],
        joinDate: json["JoinDate"],
        payroleAmount: json["PayroleAmount"],
        payroleType: json["PayroleType"],
        language: json["Language"],
        street1: json["Street1"],
        street2: json["Street2"],
        landmark: json["Landmark"],
        area: json["Area"],
        pinCode: json["PinCode"],
        city: json["City"],
        state: json["State"],
        country: json["Country"],
        additionalData: json["AdditionalData"],
        addressId: json["AddressID"],
        image: json["Image"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "AuthUserID": authUserId,
        "StoreID": storeId,
        "FirstName": firstName,
        "LastName": lastName,
        "PrimaryMobile": primaryMobile,
        "PrimaryEmail": primaryEmail,
        "SecondaryMobile": secondaryMobile,
        "SecondaryEmail": secondaryEmail,
        "Gender": gender,
        "StoreRoleID": storeRoleId,
        "WebUser": webUser,
        "PosUser": posUser,
        "DOB": dob,
        "BloodGroup": bloodGroup,
        "UserName": userName,
        "Password": password,
        "ConfirmPassword": confirmPassword,
        "Pin": pin,
        "PinHash": pinHash,
        "ConfirmPin": confirmPin,
        "JoinDate": joinDate,
        "PayroleAmount": payroleAmount,
        "PayroleType": payroleType,
        "Language": language,
        "Street1": street1,
        "Street2": street2,
        "Landmark": landmark,
        "Area": area,
        "PinCode": pinCode,
        "City": city,
        "State": state,
        "Country": country,
        "AdditionalData": additionalData,
        "AddressID": addressId,
        "Image": image,
      };
}

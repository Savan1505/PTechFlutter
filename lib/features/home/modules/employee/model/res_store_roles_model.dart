class ResStoreRolesModel {
  bool? error;
  StoreRoleData? data;
  int? code;
  String? message;
  DateTime? timeStamp;

  ResStoreRolesModel({
    this.error,
    this.data,
    this.code,
    this.message,
    this.timeStamp,
  });

  factory ResStoreRolesModel.fromJson(Map<String, dynamic> json) => ResStoreRolesModel(
        error: json["Error"],
        data: json["Data"] == null ? null : StoreRoleData.fromJson(json["Data"]),
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

class StoreRoleData {
  int? count;
  List<Role>? list;

  StoreRoleData({
    this.count,
    this.list,
  });

  factory StoreRoleData.fromJson(Map<String, dynamic> json) => StoreRoleData(
        count: json["Count"],
        list: json["List"] == null ? [] : List<Role>.from(json["List"]!.map((x) => Role.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Count": count,
        "List": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class Role {
  List<PermissionList>? permissionList;
  int? userCount;
  int? permissionCount;
  String? id;
  String? name;
  String? displayName;
  String? storeId;

  Role({
    this.permissionList,
    this.userCount,
    this.permissionCount,
    this.id,
    this.name,
    this.displayName,
    this.storeId,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        permissionList: json["PermissionList"] == null
            ? []
            : List<PermissionList>.from(json["PermissionList"]!.map((x) => PermissionList.fromJson(x))),
        userCount: json["UserCount"],
        permissionCount: json["PermissionCount"],
        id: json["ID"],
        name: json["Name"],
        displayName: json["DisplayName"],
        storeId: json["StoreID"],
      );

  Map<String, dynamic> toJson() => {
        "PermissionList":
            permissionList == null ? [] : List<dynamic>.from(permissionList!.map((x) => x.toJson())),
        "UserCount": userCount,
        "PermissionCount": permissionCount,
        "ID": id,
        "Name": name,
        "DisplayName": displayName,
        "StoreID": storeId,
      };
}

class PermissionList {
  String? storeRoleId;
  DateTime? storeRoleIdUpdatedOn;
  String? modulePermissionId;
  DateTime? modulePermissionIdUpdatedOn;
  String? permission;
  DateTime? permissionUpdatedOn;
  String? id;
  String? createdBy;
  DateTime? createdOn;
  String? updatedBy;
  DateTime? updatedOn;
  bool? active;

  PermissionList({
    this.storeRoleId,
    this.storeRoleIdUpdatedOn,
    this.modulePermissionId,
    this.modulePermissionIdUpdatedOn,
    this.permission,
    this.permissionUpdatedOn,
    this.id,
    this.createdBy,
    this.createdOn,
    this.updatedBy,
    this.updatedOn,
    this.active,
  });

  factory PermissionList.fromJson(Map<String, dynamic> json) => PermissionList(
        storeRoleId: json["StoreRoleID"],
        storeRoleIdUpdatedOn:
            json["StoreRoleID_UpdatedOn"] == null ? null : DateTime.parse(json["StoreRoleID_UpdatedOn"]),
        modulePermissionId: json["ModulePermissionID"],
        modulePermissionIdUpdatedOn: json["ModulePermissionID_UpdatedOn"] == null
            ? null
            : DateTime.parse(json["ModulePermissionID_UpdatedOn"]),
        permission: json["Permission"],
        permissionUpdatedOn:
            json["Permission_UpdatedOn"] == null ? null : DateTime.parse(json["Permission_UpdatedOn"]),
        id: json["ID"],
        createdBy: json["CreatedBy"],
        createdOn: json["CreatedOn"] == null ? null : DateTime.parse(json["CreatedOn"]),
        updatedBy: json["UpdatedBy"],
        updatedOn: json["UpdatedOn"] == null ? null : DateTime.parse(json["UpdatedOn"]),
        active: json["Active"],
      );

  Map<String, dynamic> toJson() => {
        "StoreRoleID": storeRoleId,
        "StoreRoleID_UpdatedOn": storeRoleIdUpdatedOn?.toIso8601String(),
        "ModulePermissionID": modulePermissionId,
        "ModulePermissionID_UpdatedOn": modulePermissionIdUpdatedOn?.toIso8601String(),
        "Permission": permission,
        "Permission_UpdatedOn": permissionUpdatedOn?.toIso8601String(),
        "ID": id,
        "CreatedBy": createdBy,
        "CreatedOn": createdOn?.toIso8601String(),
        "UpdatedBy": updatedBy,
        "UpdatedOn": updatedOn?.toIso8601String(),
        "Active": active,
      };
}

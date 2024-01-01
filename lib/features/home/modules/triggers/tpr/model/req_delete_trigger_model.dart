class ReqCrudOperationModel {
  String? path;
  String? value;
  String? op;

  ReqCrudOperationModel({
    this.path,
    this.value,
    this.op,
  });

  factory ReqCrudOperationModel.fromJson(Map<String, dynamic> json) => ReqCrudOperationModel(
        path: json["path"],
        value: json["value"],
        op: json["op"],
      );

  Map<String, dynamic> toJson() => {
        "path": path,
        "value": value,
        "op": op,
      };
}

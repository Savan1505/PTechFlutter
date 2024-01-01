class ReqEmployeeAccessModel {
  String? path;
  String? value;
  String? op;

  ReqEmployeeAccessModel({
    this.path,
    this.value,
    this.op = "Replace",
  });

  factory ReqEmployeeAccessModel.fromJson(Map<String, dynamic> json) => ReqEmployeeAccessModel(
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

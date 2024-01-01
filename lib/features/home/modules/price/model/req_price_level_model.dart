class ReqPriceLevelModel {
  String? name;
  String? price;
  double? rate;
  String? rateType;
  int? type;
  bool? rateAdd;

  ReqPriceLevelModel({
    this.name,
    this.price,
    this.rate,
    this.rateType,
    this.type,
    this.rateAdd,
  });

  factory ReqPriceLevelModel.fromJson(Map<String, dynamic> json) => ReqPriceLevelModel(
        name: json["Name"],
        price: json["Price"],
        rate: json["Rate"],
        rateType: json["RateType"],
        type: json["Type"],
        rateAdd: json["RateAdd"],
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "Price": price,
        "Rate": rate,
        "RateType": rateType,
        "Type": type,
        "RateAdd": rateAdd,
      };
}

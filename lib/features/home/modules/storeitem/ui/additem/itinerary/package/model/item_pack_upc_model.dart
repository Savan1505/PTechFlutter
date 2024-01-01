import 'package:ptecpos_mobile/core/utils/flavors.dart';

class ItemPackUpcModel {
  final String packUpcName;
  String? packUpcPoolId;

  ItemPackUpcModel({
    required this.packUpcName,
    this.packUpcPoolId,
  }) {
    packUpcPoolId ??= Flavors.getGuid()!;
  }
}

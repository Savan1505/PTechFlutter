import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/department/model/res_dept_taxslab_model.dart';

class TaxSlabModel {
  TaxSlab taxSlab;
  bool isSelected;

  TaxSlabModel({
    required this.taxSlab,
    this.isSelected = false,
  });
}

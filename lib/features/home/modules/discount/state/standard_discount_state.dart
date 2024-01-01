import 'package:ptecpos_mobile/core/base/base_ui_state.dart';

class StandardDiscountState extends BaseUiState<bool> {
  StandardDiscountState.loading() : super.loading();

  StandardDiscountState.completed(bool model) : super.completed(data: model);

  StandardDiscountState.error(dynamic error) : super.error(error);
}

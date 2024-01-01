import 'package:ptecpos_mobile/core/base/base_ui_state.dart';

class PriceLevelState extends BaseUiState<bool> {
  PriceLevelState.loading() : super.loading();

  PriceLevelState.completed(bool model) : super.completed(data: model);

  PriceLevelState.error(dynamic error) : super.error(error);
}

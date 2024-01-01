import 'package:ptecpos_mobile/core/base/base_ui_state.dart';

class StoreItemState extends BaseUiState<bool> {
  StoreItemState.loading() : super.loading();

  StoreItemState.completed(bool model) : super.completed(data: model);

  StoreItemState.error(dynamic error) : super.error(error);
}

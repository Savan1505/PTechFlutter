import 'package:ptecpos_mobile/core/base/base_ui_state.dart';

class StoreState extends BaseUiState<bool> {
  StoreState.loading() : super.loading();

  StoreState.completed(bool model) : super.completed(data: model);

  StoreState.error(dynamic error) : super.error(error);
}

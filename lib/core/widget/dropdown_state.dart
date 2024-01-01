import 'package:ptecpos_mobile/core/base/base_ui_state.dart';

class DropDownState extends BaseUiState<bool> {
  DropDownState.loading() : super.loading();

  DropDownState.completed(bool model) : super.completed(data: model);

  DropDownState.error(dynamic error) : super.error(error);
}

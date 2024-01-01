import 'package:ptecpos_mobile/core/base/base_ui_state.dart';

class AccessState extends BaseUiState<bool> {
  AccessState.loading() : super.loading();

  AccessState.completed(bool model) : super.completed(data: model);

  AccessState.error(dynamic error) : super.error(error);
}

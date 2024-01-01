import 'package:ptecpos_mobile/core/base/base_ui_state.dart';

class TprState extends BaseUiState<bool> {
  TprState.loading() : super.loading();

  TprState.completed(bool model) : super.completed(data: model);

  TprState.error(dynamic error) : super.error(error);
}

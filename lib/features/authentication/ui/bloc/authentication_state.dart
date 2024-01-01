import 'package:ptecpos_mobile/core/base/base_ui_state.dart';

class AuthenticationState extends BaseUiState<bool> {
  AuthenticationState.loading() : super.loading();

  AuthenticationState.completed(bool model) : super.completed(data: model);

  AuthenticationState.error(dynamic error) : super.error(error);
}

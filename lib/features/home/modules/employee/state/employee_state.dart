import 'package:ptecpos_mobile/core/base/base_ui_state.dart';

class EmployeeState extends BaseUiState<bool> {
  EmployeeState.loading() : super.loading();

  EmployeeState.completed(bool model) : super.completed(data: model);

  EmployeeState.error(dynamic error) : super.error(error);
}

class BaseUiState<T> {
  /// Holds error is state is [State.error]
  dynamic error;

  /// Holds data is state is [State.completed]
  T? data;

  /// Holds current [State]
  State? _state;

  BaseUiState();

  /// Returns [BaseUiState] with [State.loading]
  BaseUiState.loading() : _state = State.loading;

  /// Returns [BaseUiState] with [State.completed]
  BaseUiState.completed({this.data}) : _state = State.completed;

  /// Returns [BaseUiState] with [State.error]
  BaseUiState.error(this.error) : _state = State.error;

  /// Returns true if the current [state] is [State.loading]
  bool isLoading() => _state == State.loading;

  /// Returns true if the current [state] is [State.completed]
  bool isCompleted() => _state == State.completed;

  /// Returns true if the current [state] is [State.error]
  bool isError() => _state == null || _state == State.error;

  @override
  String toString() {
    return 'State is $_state';
  }
}

/// UI States
enum State { loading, completed, error }

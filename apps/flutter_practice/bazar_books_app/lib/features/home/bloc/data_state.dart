enum FetchDataStatus { initial, loading, loaded, error }

class FetchDataState<T> {
  final FetchDataStatus status;
  final List<T>? data;
  final String? errorMessage;

  const FetchDataState._({
    this.status = FetchDataStatus.initial,
    this.data,
    this.errorMessage,
  });

  const FetchDataState.initial() : this._();

  const FetchDataState.loading() : this._(status: FetchDataStatus.loading);

  const FetchDataState.loaded(List<T> data)
      : this._(status: FetchDataStatus.loaded, data: data);

  const FetchDataState.error(String errorMessage)
      : this._(status: FetchDataStatus.error, errorMessage: errorMessage);

  List<Object?> get props => [status, data, errorMessage];
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(syncQueueDatasource)
final syncQueueDatasourceProvider = SyncQueueDatasourceProvider._();

final class SyncQueueDatasourceProvider
    extends
        $FunctionalProvider<
          SyncQueueDatasource,
          SyncQueueDatasource,
          SyncQueueDatasource
        >
    with $Provider<SyncQueueDatasource> {
  SyncQueueDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncQueueDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncQueueDatasourceHash();

  @$internal
  @override
  $ProviderElement<SyncQueueDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SyncQueueDatasource create(Ref ref) {
    return syncQueueDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncQueueDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncQueueDatasource>(value),
    );
  }
}

String _$syncQueueDatasourceHash() =>
    r'12b6aa679d0e6e72ba84a5653ce6e01410ac577b';

@ProviderFor(syncService)
final syncServiceProvider = SyncServiceProvider._();

final class SyncServiceProvider
    extends $FunctionalProvider<SyncService, SyncService, SyncService>
    with $Provider<SyncService> {
  SyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncServiceHash();

  @$internal
  @override
  $ProviderElement<SyncService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SyncService create(Ref ref) {
    return syncService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncService>(value),
    );
  }
}

String _$syncServiceHash() => r'a8e5bcaa5d323ae99fddc069cb5d39d839d27782';

@ProviderFor(syncStatus)
final syncStatusProvider = SyncStatusProvider._();

final class SyncStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<SyncStatus>,
          SyncStatus,
          Stream<SyncStatus>
        >
    with $FutureModifier<SyncStatus>, $StreamProvider<SyncStatus> {
  SyncStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncStatusHash();

  @$internal
  @override
  $StreamProviderElement<SyncStatus> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<SyncStatus> create(Ref ref) {
    return syncStatus(ref);
  }
}

String _$syncStatusHash() => r'bc44a792024d8c224ad7b92ded485c5c6acf44dc';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/network/connectivity_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockConnectivity = MockConnectivity();
  });

  test('isConnected returns true for wifi', () async {
    when(
      () => mockConnectivity.checkConnectivity(),
    ).thenAnswer((_) async => [ConnectivityResult.wifi]);

    final service = ConnectivityService(connectivity: mockConnectivity);
    expect(await service.isConnected, isTrue);
  });

  test('isConnected returns false for none', () async {
    when(
      () => mockConnectivity.checkConnectivity(),
    ).thenAnswer((_) async => [ConnectivityResult.none]);

    final service = ConnectivityService(connectivity: mockConnectivity);
    expect(await service.isConnected, isFalse);
  });

  test('connectivityStream maps results to boolean values', () async {
    when(() => mockConnectivity.onConnectivityChanged).thenAnswer(
      (_) => Stream.fromIterable([
        [ConnectivityResult.none],
        [ConnectivityResult.mobile],
        [ConnectivityResult.ethernet],
      ]),
    );

    final service = ConnectivityService(connectivity: mockConnectivity);

    expect(service.connectivityStream, emitsInOrder([false, true, true]));
  });
}

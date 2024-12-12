// ignore_for_file: unused_result

import 'package:bazar_books_app/features/home/bloc/vendor_bloc/vendor_bloc.dart';
import 'package:bazar_books_app/features/home/bloc/vendor_bloc/vendor_state.dart';
import 'package:bazar_books_design/core/network/failure.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../home_mocks.dart';

void main() {
  late VendorBloc vendorBloc;
  late MockVendorRepository vendorRepository;

  setUp(() {
    vendorRepository = MockVendorRepository();
    vendorBloc = VendorBloc();
  });

  tearDown(() {
    vendorBloc.close();
  });

  group('Test fetch vendors', () {
    blocTest<VendorBloc, VendorState>(
      '''
      Scenario: Fetch vendors successfully
        Given VendorBloc has initial state as VendorState
        When GetBestVendorsEvent is added
        Then VendorBloc should emit [FetchDataState.loading(), FetchDataState.loaded(vendors)]''',
      build: () {
        when(() => vendorRepository.fetchVendors()).thenAnswer(
          (_) async => HomeMocks.mockVendorList,
        );
        return vendorBloc;
      },
      act: (bloc) => bloc.add(GetBestVendors()),
      expect: () => [
        const VendorState(status: VendorStatus.loading),
      ],
    );

    blocTest<VendorBloc, VendorState>(
      '''
      Scenario: Error fetching vendors on initial load
        Given VendorBloc has initial state as VendorState
        When GetBestVendorsEvent is added
        Then VendorBloc should emit [FetchDataState.loading(), FetchDataState.error("Failed to load vendors")]
      ''',
      build: () {
        when(() => vendorRepository.fetchVendors()).thenThrow(DioException(
          requestOptions: RequestOptions(),
          response: Response(
            statusMessage: faker.lorem.sentence(),
            data: Failure(
              409,
              message: 'Email already exists, please check again!',
            ),
            statusCode: 409,
            requestOptions: RequestOptions(),
          ),
        ));
        return vendorBloc;
      },
      act: (bloc) => bloc.add(GetBestVendors()),
      expect: () => [
        const VendorState(status: VendorStatus.loading),
      ],
    );
  });
}

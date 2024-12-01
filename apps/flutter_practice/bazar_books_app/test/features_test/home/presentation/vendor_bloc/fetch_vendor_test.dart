// ignore_for_file: unused_result

import 'package:bazar_books_app/features/home/bloc/data_state.dart';
import 'package:bazar_books_app/features/home/bloc/vendor_bloc/vendor_bloc.dart';
import 'package:bazar_books_design/core/models/vendor_model/vendor_model.dart';
import 'package:bazar_books_design/core/network/failure.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../home_mocks.dart';

void main() {
  late VendorBloc vendorBloc;
  late MockHomeRepository vendorRepository;

  setUp(() {
    vendorRepository = MockHomeRepository();
    vendorBloc = VendorBloc(vendorRepository: vendorRepository);
  });

  tearDown(() {
    vendorBloc.close();
  });

  group('Test fetch vendors', () {
    blocTest<VendorBloc, FetchDataState<Vendor>>(
      '''
      Scenario: Fetch vendors successfully
        Given VendorBloc has initial state as FetchDataState.initial()
        When GetBestVendorsEvent is added
        Then VendorBloc should emit [FetchDataState.loading(), FetchDataState.loaded(vendors)]''',
      build: () {
        when(() => vendorRepository.fetchVendors()).thenAnswer(
          (_) async => HomeMocks.mockVendorList,
        );
        return vendorBloc;
      },
      act: (bloc) => bloc.add(GetBestVendorsEvent()),
      expect: () => [
        const FetchDataState<Vendor>.loading(),
        isA<FetchDataState<Vendor>>()
          ..having(
            (entity) => entity,
            'View state FetchDataState.loaded(vendors)',
            HomeMocks.mockVendorList,
          ),
      ],
    );

    blocTest<VendorBloc, FetchDataState<Vendor>>(
      '''
      Scenario: Fetch more vendors successfully
        Given VendorBloc has state with initial list of vendors
        When FetchMoreVendorsEvent is added
        Then VendorBloc should emit [FetchDataState.loadingMore(existingVendors), FetchDataState.loaded(updatedVendors)]
      ''',
      build: () {
        vendorBloc.currentPage = 1;
        when(() => vendorRepository.fetchVendors(page: 1, limit: 10))
            .thenAnswer(
          (_) async => [],
        );
        return vendorBloc;
      },
      seed: () => FetchDataState<Vendor>.loaded(
        HomeMocks.mockVendorList,
      ),
      act: (bloc) => bloc.add(FetchMoreVendorsEvent('')),
      expect: () => [
        FetchDataState<Vendor>.loadingMore(
          HomeMocks.mockVendorList,
        ),
        FetchDataState<Vendor>.loaded(
          HomeMocks.mockVendorList,
        ),
      ],
    );

    blocTest<VendorBloc, FetchDataState<Vendor>>(
      '''
      Scenario: Fetch more vendors with empty result (end reached)
        Given VendorBloc has state with existing vendors and hasReachedEnd is false
        When FetchMoreVendorsEvent is added but no new vendors are returned
        Then VendorBloc should emit [FetchDataState.loadingMore(existingVendors), FetchDataState.loaded(existingVendors)]
      ''',
      build: () {
        vendorBloc.hasReachedEnd = false;
        vendorBloc.currentPage = 1;
        when(() => vendorRepository.fetchVendors(page: 1, limit: 10))
            .thenAnswer((_) async => []);
        return vendorBloc;
      },
      seed: () => FetchDataState<Vendor>.loaded(
        HomeMocks.mockVendorList,
      ),
      act: (bloc) => bloc.add(FetchMoreVendorsEvent('')),
      expect: () => [
        FetchDataState<Vendor>.loadingMore(
          HomeMocks.mockVendorList,
        ),
        FetchDataState<Vendor>.loaded(
          HomeMocks.mockVendorList,
        ),
      ],
      verify: (_) {
        expect(vendorBloc.hasReachedEnd, true);
      },
    );

    blocTest<VendorBloc, FetchDataState<Vendor>>(
      '''
      Scenario: Error fetching vendors on initial load
        Given VendorBloc has initial state as FetchDataState.initial()
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
      act: (bloc) => bloc.add(GetBestVendorsEvent()),
      expect: () => [
        const FetchDataState<Vendor>.loading(),
        const FetchDataState<Vendor>.error(
            'Email already exists, please check again!'),
      ],
    );

    blocTest<VendorBloc, FetchDataState<Vendor>>(
      '''
      Scenario: Error fetching more vendors
        Given VendorBloc has existing vendors and fetch more is requested
        When FetchMoreVendorsEvent is added but an error occurs
        Then VendorBloc should emit [FetchDataState.loadingMore(existingVendors), FetchDataState.error("Failed to load more vendors")]
      ''',
      build: () {
        vendorBloc.currentPage = 1;
        when(() => vendorRepository.fetchVendors(page: 1, limit: 10))
            .thenThrow(Exception(
          HomeMocks.failureMock,
        ));
        return vendorBloc;
      },
      seed: () => FetchDataState<Vendor>.loaded(
        HomeMocks.mockVendorList,
      ),
      act: (bloc) => bloc.add(FetchMoreVendorsEvent('')),
      expect: () => [
        FetchDataState<Vendor>.loadingMore(
          HomeMocks.mockVendorList,
        ),
        const FetchDataState<Vendor>.error('Default error'),
      ],
    );
  });
}

import 'dart:async';

import 'package:bazar_books_app/features/home/data/vendor_repository/vendor_repository.dart';
import 'package:bazar_books_design/core/core.dart';
import 'package:bazar_books_design/db/isar_service.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:collection/collection.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

// Service Mocks

class MockIsarService extends Mock implements IsarService {}

class MockVendorApiService extends Mock implements ApiService {}

class MockVendorRepository extends Mock implements VendorRepository {}

class MockQuery extends Mock implements Query {}

// Data Mocks
class VendorMocks {
  static final mockVendorsPage = faker.randomGenerator.decimal().toInt();

  static final mockVendorsLimit = faker.randomGenerator.decimal().toInt();

  static final mockVendorList = [
    Vendor(
      id: faker.guid.guid(),
      headlines: faker.lorem.word(),
    ),
    Vendor(
      id: faker.guid.guid(),
      headlines: faker.lorem.word(),
    ),
  ];

  static final expiredData = [
    const Vendor(
      id: "1",
      headlines: "Old Vendor",
      numberStar: 4,
      imageUrl: "https://example.com/old.png",
      starRating: 3,
      publications: "30 publications",
    ),
  ];

  static final newData = [
    const Vendor(
      id: "2",
      headlines: "New Vendor",
      numberStar: 5,
      imageUrl: "https://example.com/new.png",
      starRating: 4,
      publications: "100 publications",
    ),
  ];

  static final mockVendor = Vendor(
    id: faker.guid.guid(),
    headlines: faker.lorem.word(),
  );

  static final failureMock = Exception(faker.lorem.sentence());

  static const mockKeyVendors = 'Vendors';

  static final vendors = List.generate(
    10,
    (index) => Vendor(id: '$index', headlines: 'Vendor $index'),
  );

  static final mockVendorPagination = List.generate(
    10,
    (index) => Vendor(id: '${index + 10}', headlines: 'Vendor ${index + 10}'),
  );

  static final mockEmpty = [];

  static List<Map<String, dynamic>> mockVendorsResponse() {
    return List.generate(
      10,
      (index) => Vendor(id: '$index', headlines: 'Vendor $index'),
    ).map((v) => v.toJson()).toList();
  }
}

class MockStorage extends StorageInterface {
  static const data = "storage";
  List<StoredQuery> store = [];
  @override
  void close() {}

  @override
  void delete(String key) {}

  @override
  void deleteAll() {
    store = [];
  }

  @override
  FutureOr<StoredQuery?> get(String key) {
    final item = store.firstWhereOrNull((e) => e.key == key);
    if (item == null) return null;
    return item;
  }

  @override
  void put(StoredQuery query) {
    final storedIndex = store.indexWhere((e) => e.key == query.key);
    if (storedIndex == -1) {
      store.add(query);
    } else {
      store[storedIndex] = query;
    }
  }
}

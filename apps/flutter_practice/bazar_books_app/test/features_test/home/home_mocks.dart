import 'package:bazar_books_app/features/home/data/author_repository/author_repository.dart';
import 'package:bazar_books_app/features/home/data/product_repository/product_repository.dart';
import 'package:bazar_books_app/features/home/data/vendor_repository/vendor_repository.dart';
import 'package:bazar_books_design/core/core.dart';
import 'package:bazar_books_design/db/isar_service.dart';
import 'package:bazar_books_design/db/product_service.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

// Service Mocks
class MockHomeApiService extends Mock implements ApiService {}

class MockProductService extends Mock implements ProductService {}

class MockIsarService extends Mock implements IsarService {}

class MockHomeRepository extends Mock implements AuthorRepository {}

class MockProductRepository extends Mock implements ProductRepository {}

class MockProductRepositoryImpl extends Mock implements ProductRepositoryImpl {}

class MockApiService extends Mock implements ApiService {}

class MockErrorHandler extends Mock implements ErrorHandler {}

class MockVendorRepository extends Mock implements VendorRepository {}

// Data Mocks
class HomeMocks {
  static final mockProduct = Product(
      id: faker.guid.guid(),
      title: faker.lorem.word(),
      description: faker.lorem.sentence(),
      imageUrl: faker.image.loremPicsum(),
      price: faker.randomGenerator.decimal().toString(),
      starRating: faker.randomGenerator.decimal().toInt(),
      imageUrlOffer: [faker.image.loremPicsum()]);

  static final mockProductDetail = Product(
    id: faker.guid.guid(),
    title: faker.lorem.word(),
    description: faker.lorem.sentence(),
    imageUrl: faker.image.loremPicsum(),
    price: faker.randomGenerator.decimal().toString(),
    starRating: faker.randomGenerator.decimal().toInt(),
    imageUrlOffer: [faker.image.loremPicsum()],
  );

  static final mockProducId = faker.guid.guid();

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

  static final mockVendor = Vendor(
    id: faker.guid.guid(),
    headlines: faker.lorem.word(),
  );

  static final mockAuthorsList = [
    Author(
      id: faker.guid.guid(),
      fullName: faker.lorem.word(),
    ),
    Author(
      id: faker.guid.guid(),
      fullName: faker.lorem.word(),
    ),
  ];

  static final mockAuthor = Author(
    id: faker.guid.guid(),
    fullName: faker.lorem.word(),
    occupation: faker.lorem.word(),
  );

  static final mockAuthorId = faker.guid.guid();

  static final mockAuthorProfileId = faker.guid.guid();

  static final mockFetchAuthors = [
    Author(
      id: faker.guid.guid(),
      fullName: faker.lorem.word(),
    ),
    Author(
      id: faker.guid.guid(),
      fullName: faker.lorem.word(),
    ),
  ];

  static final mockFetchAuthorProfile = Author(
    id: faker.guid.guid(),
    fullName: faker.lorem.word(),
    occupation: faker.lorem.word(),
  );

  static final mockProductList = [
    Product(
        id: faker.guid.guid(),
        title: faker.lorem.word(),
        description: faker.lorem.sentence(),
        imageUrl: faker.image.loremPicsum(),
        price: faker.randomGenerator.decimal().toString(),
        starRating: faker.randomGenerator.decimal().toInt(),
        imageUrlOffer: [faker.image.loremPicsum()])
  ];
  static final failureMock = Exception(faker.lorem.sentence());
}

import 'package:bazar_books_app/features/auth/data/auth_repository.dart';
import 'package:bazar_books_app/features/auth/data/auth_repository_impl.dart';
import 'package:bazar_books_app/features/category/data/category_repository.dart';
import 'package:bazar_books_app/features/home/data/product_repository/product_repository.dart';
import 'package:bazar_books_design/core/core.dart';
import 'package:bazar_books_design/db/isar_service.dart';
import 'package:bazar_books_design/db/product_service.dart';
import 'package:dio/dio.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

// Service Mocks
class MockApiService extends Mock implements ApiService {}

class MockProductService extends Mock implements ProductService {}

class MockIsarService extends Mock implements IsarService {}

class MockProductRepository extends Mock implements ProductRepositoryImpl {}

class MockErrorHandler extends Mock implements ErrorHandler {}

class MockCategoryRepository extends Mock implements CategoryRepositoryImpl {}

class MockAuthRepositoryImpl extends Mock implements AuthRepositoryImpl {}

class MockAuthRepository extends Mock implements AuthRepository {}

// Data Mocks
class ProfileMock {
  static final mockProduct = Product(
      apiId: faker.guid.guid(),
      title: faker.lorem.word(),
      description: faker.lorem.sentence(),
      imageUrl: faker.image.loremPicsum(),
      price: faker.randomGenerator.decimal().toString(),
      starRating: faker.randomGenerator.decimal().toInt(),
      imageUrlOffer: [faker.image.loremPicsum()]);

  static final mockProductDetail = Product(
    apiId: faker.guid.guid(),
    title: faker.lorem.word(),
    description: faker.lorem.sentence(),
    imageUrl: faker.image.loremPicsum(),
    price: faker.randomGenerator.decimal().toString(),
    starRating: faker.randomGenerator.decimal().toInt(),
    imageUrlOffer: [faker.image.loremPicsum()],
  );

  static final mockproductsFromIsar = [
    Product(apiId: '1', title: 'Product 1', category: 'Electronics'),
    Product(apiId: '2', title: 'Product 2', category: 'Electronics'),
  ];

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
        apiId: faker.guid.guid(),
        title: faker.lorem.word(),
        description: faker.lorem.sentence(),
        imageUrl: faker.image.loremPicsum(),
        price: faker.randomGenerator.decimal().toString(),
        starRating: faker.randomGenerator.decimal().toInt(),
        imageUrlOffer: [faker.image.loremPicsum()])
  ];
  static final failureMock = Exception(faker.lorem.sentence());

  static final mockDioError = DioException(
    requestOptions: RequestOptions(),
    response: Response(
      statusCode: 404,
      statusMessage: 'Not Found',
      requestOptions: RequestOptions(),
    ),
  );
}
